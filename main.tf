module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.rg_name  # Refers to variable "rg_name" in root variables.tf
  location = var.location # Refers to variable "location" in root variables.tf
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
  deploy_bastion      = false # Set to false to avoid costs for Bastion if not demonstrating it, set to true to deploy Bastion
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.network.subnet_id
  deploy_vm           = false # set to false to avoid costs for VM if not demonstrating it, set to true to deploy the VM
}