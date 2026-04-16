variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "vnet_address_space" { type = string }
variable "subnet_address_prefix" { type = string }
variable "web_ports" { type = list(string) }
variable "bastion_subnet_prefix" {
  type        = string
  description = "The CIDR block for the Bastion subnet"
}