resource "azurerm_synapse_managed_private_endpoint" "synapse_managed_private_endpoint_monitor_private_link_scope" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  name                 = "AzureMonitorPrivateLinkScope"

  target_resource_id = azurerm_monitor_private_link_scope.mpls.id
  subresource_name   = "azuremonitor"

  depends_on = [
    azurerm_private_endpoint.synapse_workspace_private_endpoint_dev,
  ]
}

resource "null_resource" "synapse_managed_private_endpoint_monitor_private_link_scope_approval" {
  triggers = {
    run_once = "true"
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../scripts/"
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_monitor_private_link_scope.mpls.id}' -SynapseWorkspaceName '${azurerm_synapse_workspace.synapse_workspace.name}' -SynapseManagedPrivateEndpointName '${azurerm_synapse_managed_private_endpoint.synapse_managed_private_endpoint_monitor_private_link_scope.name}'"
  }
}

resource "azurerm_synapse_managed_private_endpoint" "synapse_managed_private_endpoint_datalake" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  name                 = "DataLake"

  target_resource_id = azurerm_storage_account.datalake.id
  subresource_name   = "dfs"

  depends_on = [
    azurerm_private_endpoint.synapse_workspace_private_endpoint_dev,
  ]
}

resource "null_resource" "synapse_managed_private_endpoint_datalake_approval" {
  triggers = {
    run_once = "true"
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../scripts/"
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_storage_account.datalake.id}' -SynapseWorkspaceName '${azurerm_synapse_workspace.synapse_workspace.name}' -SynapseManagedPrivateEndpointName '${azurerm_synapse_managed_private_endpoint.synapse_managed_private_endpoint_datalake.name}'"
  }
}
