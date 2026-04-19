output "resume_url" {
  value       = module.storage.website_url
  description = "The public URL for the static website"
}

output "api_url" {
  value       = module.api.api_url
  description = "The FQDN of the backend Container App"
}