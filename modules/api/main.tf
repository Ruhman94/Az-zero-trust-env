resource "azurerm_log_analytics_workspace" "law" {
  name                = "resume-law-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                       = "resume-env-001"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_container_app" "api" {
  name                         = var.function_app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "resume-api-container"
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
    
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  
  }
}