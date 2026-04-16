output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}