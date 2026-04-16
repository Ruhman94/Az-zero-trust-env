variable "resource_group_name" {}
variable "location" {}
variable "bastion_subnet_id" {}
variable "deploy_bastion" {
  type    = bool
  default = false # Set to false to avoid costs for Bastion if not demonstrating it, set to true to deploy Bastion
}