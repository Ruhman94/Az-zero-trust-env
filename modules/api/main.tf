resource "azurerm_container_app" "api" {
  name                         = var.function_app_name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name = "resume-api-container"
      # Temporary placeholder image to establish infrastructure
      image  = "amm94/amresumeapi:v1"
      cpu    = 0.25
      memory = "0.5Gi"

      # Injecting your Cosmos DB keys securely into the container
      env {
        name  = "COSMOS_ENDPOINT"
        value = var.cosmos_endpoint
      }
      env {
        name  = "COSMOS_KEY"
        value = var.cosmos_key
      }
    }
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80

    cors {
      allowed_origins = [
        "https://aalmohaimeed.com",
        "https://www.aalmohaimeed.com",
        "http://127.0.0.1:5500",
        "http://localhost:5500"
      ]
      allowed_methods    = ["GET", "POST", "OPTIONS"]
      allowed_headers    = ["Content-Type"] # Locked down from "*"
      max_age_in_seconds = 3600
    }

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
