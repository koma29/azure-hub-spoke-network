variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-hub-spoke-network"
}