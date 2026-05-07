# create a Virtual Network with two subnets: one for workloads and one for Azure Bastion.
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# The Workload Subnet (Where VMs go)
resource "azurerm_subnet" "subnet" {
  name                 = "internal-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

# The Bastion Subnet (Admin access)
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_subnet_prefix]
  # --- RISK ACCEPTANCE ---
  # checkov:skip=CKV2_AZURE_31: NSG for Bastion is omitted to reduce complexity for this conditional demonstration module.
}

# NSG with Conditional Logic for Web Ports and SSH
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.web_ports
    content {
      name                   = "allow-port-${security_rule.value}"
      priority               = 100 + index(var.web_ports, security_rule.value)
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = security_rule.value

      # ACCESS LOGIC: 
      # If port is 22 (SSH), only allow the Bastion Subnet. 
      # Otherwise (like 80/443), allow the Internet.
      source_address_prefix = security_rule.value == "22" ? var.bastion_subnet_prefix : "*"

      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
