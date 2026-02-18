# Container Apps Environment — analogous to ECS cluster (Consumption-only, no Dedicated profile)
resource "azurerm_container_app_environment" "main" {
  name                               = "env-autoscaling"
  location                           = azurerm_resource_group.main.location
  resource_group_name                = azurerm_resource_group.main.name
  infrastructure_subnet_id           = azurerm_subnet.aca_subnet.id
  infrastructure_resource_group_name = "${azurerm_resource_group.main.name}-nodes"
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.main.id

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 30
  }

  tags = {}
}

# Container App — analogous to ECS service; ingress analogous to ALB
resource "azurerm_container_app" "app" {
  name                         = "demopython"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app_identity.id]
  }

  registry {
    server   = var.acr_login_server
    identity = azurerm_user_assigned_identity.app_identity.id
  }

  template {
    container {
      name   = "demo-python"
      image  = var.container_image
      cpu    = 0.5
      memory = "1Gi"
      env {
        name  = "APP_ENV"
        value = "production"
      }
    }

    min_replicas = var.min_size
    max_replicas = var.max_size

    custom_scale_rule {
      name             = "cpu-scaling"
      custom_rule_type = "cpu"
      metadata = {
        type  = "Utilization"
        value = tostring(var.scale_target_value)
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 5000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
