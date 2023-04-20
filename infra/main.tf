locals {
  tags           = { azd-env-name : var.environment_name }
  sha            = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment_name}"
  location = var.location
  tags     = local.tags
}

module "loganalytics" {
  source         = "./modules/loganalytics"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = local.tags
  resource_token = local.resource_token
}

module "keyvault" {
  source                     = "./modules/keyvault"
  location                   = var.location
  rg_name                    = azurerm_resource_group.rg.name
  tags                       = local.tags
  resource_token             = local.resource_token
  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  secretstore_admins         = var.secretstore_admins
}

module "aca" {
  source                    = "./modules/aca"
  location                  = var.location
  rg_name                   = azurerm_resource_group.rg.name
  tags                      = local.tags
  resource_token            = local.resource_token
  loganalytics_id           = module.loganalytics.LOGANALYTICS_ID
  keyvault_name             = module.keyvault.KEYVAULT_NAME
  kv_consumer_client_id     = module.keyvault.KEYVAULT_CONSUMER_CLIENT_ID
  eh_load_connection_string = module.eventhub.LOAD_CONNECTION_STRING
  sb_load_connection_string = module.servicebus.LOAD_CONNECTION_STRING
}

module "loadtest" {
  source         = "./modules/loadtest"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = local.tags
  resource_token = local.resource_token
}

module "acr" {
  source         = "./modules/acr"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = local.tags
  resource_token = local.resource_token
}

module "eventhub" {
  source         = "./modules/eventhub"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = local.tags
  resource_token = local.resource_token
}

module "servicebus" {
  source         = "./modules/servicebus"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = local.tags
  resource_token = local.resource_token
}

module "receiver" {
  source                       = "./modules/receiver"
  location                     = var.location
  rg_name                      = azurerm_resource_group.rg.name
  tags                         = local.tags
  resource_token               = local.resource_token
  app_name                     = "receiver"
  app_image                    = var.receiver_image
  container_app_environment_id = module.aca.CONTAINER_APP_ENV_ID
  login_server                 = module.acr.CONTAINER_REGISTRY_ENDPOINT
  registry_identity            = module.acr.CONTAINER_REGISTRY_PULL_IDENTITY_RESOURCE_ID
}

module "sender" {
  source                       = "./modules/sender"
  location                     = var.location
  rg_name                      = azurerm_resource_group.rg.name
  tags                         = local.tags
  resource_token               = local.resource_token
  app_name                     = "sender"
  app_image                    = var.sender_image
  container_app_environment_id = module.aca.CONTAINER_APP_ENV_ID
  login_server                 = module.acr.CONTAINER_REGISTRY_ENDPOINT
  registry_identity            = module.acr.CONTAINER_REGISTRY_PULL_IDENTITY_RESOURCE_ID
}
