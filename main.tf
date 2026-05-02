module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.rg_name  # Refers to variable "rg_name" in root variables.tf
  location = var.location # Refers to variable "location" in root variables.tf
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "resume-law-001"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                       = "resume-env-001"
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}
# ==========================================

module "database" {
  source              = "./modules/database"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  
  cosmos_account_name = "amresume-db-001" # Ensure this remains globally unique
}

module "api" {
  source                       = "./modules/api"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = module.resource_group.name
  location                     = module.resource_group.location 
  
  # GLOBALLY UNIQUE NAMES
  function_app_name   = "amresume-api-001"
  fn_storage_name     = "amapistore001"

  # Pass outputs from previous modules directly into the API module
  frontend_url        = module.storage.website_url
  cosmos_endpoint     = module.database.endpoint
  cosmos_key          = module.database.primary_key
}

module "network" {
  source                = "./modules/network"
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  vnet_name             = "prod-vnet"
  vnet_address_space    = "10.0.0.0/16"
  subnet_address_prefix = "10.0.1.0/24"
  web_ports             = ["80", "443", "22"]
  bastion_subnet_prefix = "10.0.2.0/26"
}

module "storage" {
  source              = "./modules/storage"
  storage_name        = var.storage_account_name # Refers to root variables.tf
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  allowed_subnet_id   = module.network.subnet_id
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  bastion_subnet_id   = module.network.bastion_subnet_id
  deploy_bastion      = false # Set to false to avoid costs for Bastion
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_id
  deploy_vm           = false # set to false to avoid costs for VM
}