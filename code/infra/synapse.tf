resource "azurerm_synapse_workspace" "synapse_workspace" {
  name                = "${local.prefix}-synw001"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  azuread_authentication_only          = true
  compute_subnet_id                    = null
  data_exfiltration_protection_enabled = true
  linking_allowed_for_aad_tenant_ids   = []
  managed_resource_group_name          = "${local.prefix}-synw001-rg"
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = true
  purview_id                           = null
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.storage_data_lake_gen2_filesystem_synapse.id

  dynamic "github_repo" {
    for_each = length(compact(values(var.synapse_workspace_github_repo))) == 5 ? [var.synapse_workspace_github_repo] : []
    content {
      account_name    = github_repo.value["account_name"]
      branch_name     = github_repo.value["branch_name"]
      git_url         = github_repo.value["git_url"]
      repository_name = github_repo.value["repository_name"]
      root_folder     = github_repo.value["root_folder"]
    }
  }
}

resource "azurerm_synapse_workspace_aad_admin" "synapse_workspace_aad_admin" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  login                = "AzureAD Admin"
  object_id            = var.synapse_workspace_admin_object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id

  depends_on = [
    azurerm_synapse_workspace_key.synapse_workspace_key
  ]
}

resource "azurerm_synapse_workspace_sql_aad_admin" "synapse_workspace_sql_aad_admin" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  login                = "AzureAD Admin"
  object_id            = var.synapse_workspace_admin_object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id

  depends_on = [
    azurerm_synapse_workspace_key.synapse_workspace_key
  ]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_synapse_workspace" {
  resource_id = azurerm_synapse_workspace.synapse_workspace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_synapse_workspace" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_synapse_workspace.synapse_workspace.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_synapse_workspace.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_synapse_workspace.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "synapse_workspace_private_endpoint_dev" {
  name                = "${azurerm_synapse_workspace.synapse_workspace.name}-dev-pe"
  location            = var.location
  resource_group_name = azurerm_synapse_workspace.synapse_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_synapse_workspace.synapse_workspace.name}-dev-nic"
  private_service_connection {
    name                           = "${azurerm_synapse_workspace.synapse_workspace.name}-dev-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_workspace.synapse_workspace.id
    subresource_names              = ["Dev"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_synapse_dev == "" ? [] : [1]
    content {
      name = "${azurerm_synapse_workspace.synapse_workspace.name}-dev-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_synapse_dev
      ]
    }
  }
}

resource "azurerm_private_endpoint" "synapse_workspace_private_endpoint_sql" {
  name                = "${azurerm_synapse_workspace.synapse_workspace.name}-sql-pe"
  location            = var.location
  resource_group_name = azurerm_synapse_workspace.synapse_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_synapse_workspace.synapse_workspace.name}-sql-nic"
  private_service_connection {
    name                           = "${azurerm_synapse_workspace.synapse_workspace.name}-sql-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_workspace.synapse_workspace.id
    subresource_names              = ["Sql"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_synapse_sql == "" ? [] : [1]
    content {
      name = "${azurerm_synapse_workspace.synapse_workspace.name}-sql-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_synapse_sql
      ]
    }
  }
}

resource "azurerm_private_endpoint" "synapse_workspace_private_endpoint_sqlondemand" {
  name                = "${azurerm_synapse_workspace.synapse_workspace.name}-sqlondemand-pe"
  location            = var.location
  resource_group_name = azurerm_synapse_workspace.synapse_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_synapse_workspace.synapse_workspace.name}-sqlondemand-nic"
  private_service_connection {
    name                           = "${azurerm_synapse_workspace.synapse_workspace.name}-sqlondemand-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_synapse_workspace.synapse_workspace.id
    subresource_names              = ["SqlOnDemand"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_synapse_sql == "" ? [] : [1]
    content {
      name = "${azurerm_synapse_workspace.synapse_workspace.name}-dev-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_synapse_sql
      ]
    }
  }
}
