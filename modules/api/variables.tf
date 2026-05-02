variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "function_app_name" { 
  type        = string 
  description = "Globally unique name for the API"
}

variable "fn_storage_name" { 
  type        = string 
  description = "Globally unique name for the function's backend storage"
}

variable "cosmos_endpoint" { type = string }
variable "cosmos_key" { 
  type      = string
  sensitive = true 
}

variable "frontend_url" {
  type        = string
  description = "The static website URL for strict CORS configuration"
}

variable "container_app_environment_id" {
  type        = string
  description = "The ID of the Container App Environment"
}