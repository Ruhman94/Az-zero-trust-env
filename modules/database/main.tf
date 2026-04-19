resource "azurerm_cosmosdb_account" "resume_db" {
  name                = var.cosmos_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # Enforces pay-per-request pricing (FinOps)
  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "sqldb" {
  name                = "ResumeStructure"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.resume_db.name
}

resource "azurerm_cosmosdb_sql_container" "counter_container" {
  name                  = "VisitorCount"
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.resume_db.name
  database_name         = azurerm_cosmosdb_sql_database.sqldb.name
  partition_key_paths   = ["/id"]
}