variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "cosmos_account_name" {
  type        = string
  description = "Globally unique name for the Cosmos DB account"
}