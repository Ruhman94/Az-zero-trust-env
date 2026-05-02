resource "azurerm_storage_account" "secure_storage" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.allowed_subnet_id]
    bypass                     = ["AzureServices"]
    ip_rules                   =[ "143.92.147.224" ]
  }
}

resource "azurerm_storage_account_static_website" "website_config" {
  storage_account_id = azurerm_storage_account.secure_storage.id
  index_document     = "index.html"
  error_404_document = "404.html"
}