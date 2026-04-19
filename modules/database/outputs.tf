output "endpoint" {
  value       = azurerm_cosmosdb_account.resume_db.endpoint
  description = "Cosmos DB endpoint URI"
}

output "primary_key" {
  value       = azurerm_cosmosdb_account.resume_db.primary_key
  description = "Primary master key for Cosmos DB authentication"
  sensitive   = true
}