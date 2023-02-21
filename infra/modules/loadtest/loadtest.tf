resource "azurerm_load_test" "loadtest" {
  name                = "lt${var.resource_token}"
  resource_group_name = var.rg_name
  location            = var.location
  tags                = var.tags
}
