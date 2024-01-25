data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azapi_resource" "machine_learning_registry" {
  for_each = var.machine_learning_registries

  type        = "Microsoft.MachineLearningServices/registries@2023-10-01"
  resource_id = each.value.resource_id

  response_export_values = ["*"]
}

data "azurerm_subnet" "subnet" {
  name                 = local.subnet.name
  virtual_network_name = local.subnet.virtual_network_name
  resource_group_name  = local.subnet.resource_group_name
}
