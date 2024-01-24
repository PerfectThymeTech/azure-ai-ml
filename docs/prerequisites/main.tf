resource "azurerm_resource_group" "resource_group_ml_registry" {
  name     = "${local.prefix}-mlr-rg"
  location = var.location
  tags     = var.tags
}
