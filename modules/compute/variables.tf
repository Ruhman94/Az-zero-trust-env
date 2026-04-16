variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "subnet_id"           { type = string }
variable "vm_name"             { default = "prod-web-vm" }
variable "deploy_vm" {
  type    = bool
  default = false # Set to true to deploy the VM, false to skip VM deployment
}