output "storage_id" { 
  value       = azurerm_storage_account.secure_storage.id
  description = "The backend Azure Resource ID of the storage account."
}

output "website_url" {
  value       = azurerm_storage_account.secure_storage.primary_web_endpoint
  description = "The actual https:// link to the static website."
}