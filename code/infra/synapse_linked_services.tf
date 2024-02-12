resource "azurerm_synapse_linked_service" "synapse_linked_service_storage_account_external" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  name                 = "DataLake"

  description          = "Data Lake used for data."
  type                 = "AzureBlobFS"
  type_properties_json = <<JSON
  {
    "url": "${azurerm_storage_account.datalake.primary_dfs_endpoint}"
  }
  JSON
  integration_runtime {
    name = local.linked_service_integration_runtime_name
  }

  depends_on = [
    azurerm_private_endpoint.synapse_workspace_private_endpoint_dev,
    azurerm_synapse_managed_private_endpoint.synapse_managed_private_endpoint_datalake,
  ]
}
