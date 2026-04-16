variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources"
}

variable "storage_account_name" {
  type        = string
  description = "Globaly unique name for the storage account"
}