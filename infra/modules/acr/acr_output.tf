output "CONTAINER_REGISTRY_NAME" {
  value = azurerm_container_registry.acr.name
}

output "CONTAINER_REGISTRY_ENDPOINT" {
  value = azurerm_container_registry.acr.login_server
}

output "CONTAINER_REGISTRY_PULL_IDENTITY_RESOURCE_ID" {
  value = azurerm_user_assigned_identity.acr_pull_identity.id
}

output "CONTAINER_REGISTRY_PULL_IDENTITY_CLIENT_ID" {
  value = azurerm_user_assigned_identity.acr_pull_identity.client_id
}

output "CONTAINER_REGISTRY_PULL_IDENTITY_PRINCIPAL_ID" {
  value = azurerm_user_assigned_identity.acr_pull_identity.principal_id
}
