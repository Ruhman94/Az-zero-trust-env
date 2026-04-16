# Bastion resource with conditional deployment based on variable
resource "azurerm_public_ip" "bastion_pip" {
  count               = var.deploy_bastion ? 1 : 0
  name                = "pip-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# The Bastion Host, only deployed if deploy_bastion is true
resource "azurerm_bastion_host" "main" {
  count               = var.deploy_bastion ? 1 : 0
  name                = "bastion-service"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip[0].id
  }
}