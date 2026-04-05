output "resource_group_name" {
  value = azurerm_resource_group.hub_spoke_rg.name
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub_vnet.name
}

output "spoke_vnet_name" {
  value = azurerm_virtual_network.spoke_vnet.name
}

output "hub_subnet_name" {
  value = azurerm_subnet.hub_subnet.name
}

output "spoke_subnet_name" {
  value = azurerm_subnet.spoke_subnet.name
}

output "hub_to_spoke_peering_name" {
  value = azurerm_virtual_network_peering.hub_to_spoke.name
}

output "spoke_to_hub_peering_name" {
  value = azurerm_virtual_network_peering.spoke_to_hub.name
}

output "hub_nsg_name" {
  value = azurerm_network_security_group.hub_nsg.name
}

output "spoke_nsg_name" {
  value = azurerm_network_security_group.spoke_nsg.name
}