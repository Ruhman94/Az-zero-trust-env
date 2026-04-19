resource "azurerm_storage_account" "secure_storage" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
   index_document           = "index.html"
   error_404_document       = "404.html"
  }

  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [var.allowed_subnet_id]
    bypass                     = ["AzureServices"]
    ip_rules                   =[ "143.92.147.224" ]
  }
}