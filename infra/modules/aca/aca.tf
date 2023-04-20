resource "azurerm_container_app_environment" "aca_env" {
  name                = "cae-${var.resource_token}"
  resource_group_name = var.rg_name
  location            = var.location
  tags                = var.tags

  log_analytics_workspace_id = var.loganalytics_id
}

resource "azurerm_container_app_environment_dapr_component" "dapr_component_secretstore" {
  name                         = "secretstore"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  component_type               = "secretstores.azure.keyvault"
  version                      = "v1"
  metadata {
    name  = "vaultName"
    value = var.keyvault_name
  }
  metadata {
    name  = "spnClientId"
    value = var.kv_consumer_client_id
  }
}

resource "azurerm_container_app_environment_dapr_component" "dapr_component_pubsub_sb" {
  name                         = "pubsub-loadtest-sb"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  component_type               = "pubsub.azure.servicebus"
  version                      = "v1"
  metadata {
    name  = "connectionString"
    value = var.sb_load_connection_string
  }
  scopes = [
    "sender",
    "receiver"
  ]
}

resource "azurerm_container_app_environment_dapr_component" "dapr_component_pubsub_eh" {
  name                         = "pubsub-loadtest-eh"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  component_type               = "pubsub.azure.servicebus"
  version                      = "v1"
  metadata {
    name  = "connectionString"
    value = var.eh_load_connection_string
  }
  scopes = [
    "sender",
    "receiver"
  ]
}
