terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # This points to the remote backend where Terraform will store the state file
  backend "azurerm" {
    resource_group_name  = "tfstate-mgmt-rg"
    storage_account_name = "amtfstate99" # Your unique name for the storage account
    container_name       = "tfstate-container"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}