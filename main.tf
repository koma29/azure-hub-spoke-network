resource "azurerm_resource_group" "hub_spoke_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-hub"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = "subnet-hub-shared"
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "vnet-spoke-app"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
}

resource "azurerm_subnet" "spoke_subnet" {
  name                 = "subnet-spoke-workload"
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_network_security_group" "hub_nsg" {
  name                = "nsg-hub-shared"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
}

resource "azurerm_network_security_group" "spoke_nsg" {
  name                = "nsg-spoke-workload"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
}

resource "azurerm_subnet_network_security_group_association" "hub_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.hub_subnet.id
  network_security_group_id = azurerm_network_security_group.hub_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "spoke_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.spoke_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_nsg.id
}

resource "azurerm_network_security_rule" "hub_allow_spoke_inbound" {
  name                        = "allow-spoke-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.1.0.0/16"
  destination_address_prefix  = "10.0.1.0/24"
  resource_group_name         = azurerm_resource_group.hub_spoke_rg.name
  network_security_group_name = azurerm_network_security_group.hub_nsg.name
}

resource "azurerm_network_security_rule" "spoke_allow_hub_inbound" {
  name                        = "allow-hub-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/16"
  destination_address_prefix  = "10.1.1.0/24"
  resource_group_name         = azurerm_resource_group.hub_spoke_rg.name
  network_security_group_name = azurerm_network_security_group.spoke_nsg.name
}