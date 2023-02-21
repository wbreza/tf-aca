output "KEYVAULT_NAME" {
  value = azurerm_key_vault.kv.name
}

output "KEYVAULT_CONSUMER_CLIENT_ID" {
  value = azurerm_user_assigned_identity.kv_consumer_identity.client_id
}
