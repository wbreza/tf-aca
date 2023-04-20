resource "azurerm_container_app" "sender" {
  name                         = "ca-${var.app_name}-${var.resource_token}"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.rg_name
  revision_mode                = "Single"
  tags                         = merge(var.tags, { "azd-service-name" = var.app_name })

  identity {
    type         = "UserAssigned"
    identity_ids = [var.registry_identity]
  }

  ingress {
    external_enabled = true
    target_port = 80
    traffic_weight {
      latest_revision = true
      percentage = 100
    }
  }

  registry {
    server   = var.login_server
    identity = var.registry_identity
  }

  dapr {
    app_id       = var.app_name
    app_port     = 80
    app_protocol = "http"
  }

  template {
    container {
      name   = var.app_name
      image  = var.app_image
      cpu    = 0.25
      memory = "0.5Gi"
      liveness_probe {
        port      = 80
        path      = "health"
        transport = "HTTP"
      }
      readiness_probe {
        port      = 80
        path      = "health"
        transport = "HTTP"
      }
    }
  }
}
