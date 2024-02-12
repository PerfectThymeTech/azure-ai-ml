# Spark pools
resource "azurerm_synapse_spark_pool" "spark_pool" {
  for_each = var.synapse_workspace_spark_pools

  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  name                 = each.key

  auto_pause {
    delay_in_minutes = each.value.autopause_delay_in_minutes
  }
  node_count = each.value.scale.node_count
  auto_scale {
    min_node_count = each.value.scale.min_node_count
    max_node_count = each.value.scale.max_node_count
  }
  cache_size                          = each.value.cache_size
  compute_isolation_enabled           = each.value.compute_isolation_enabled
  dynamic_executor_allocation_enabled = each.value.dynamic_executor_allocation.enabled
  min_executors                       = each.value.dynamic_executor_allocation.min_executors
  max_executors                       = each.value.dynamic_executor_allocation.max_executors
  node_size                           = each.value.node_size
  node_size_family                    = each.value.node_size_family
  session_level_packages_enabled      = each.value.session_level_packages_enabled
  spark_events_folder                 = "/events"
  spark_log_folder                    = "/logs"
  spark_version                       = each.value.spark_version
  dynamic "spark_config" {
    for_each = each.value.spark_config == "" ? [] : [1]
    content {
      content  = each.value.spark_config
      filename = "${each.key}_config.txt"
    }
  }
  dynamic "spark_config" {
    for_each = each.value.library_requirement == "" ? [] : [1]
    content {
      content  = each.value.library_requirement
      filename = "${each.key}_requirements.txt"
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

# Integration runtimes
resource "azurerm_synapse_integration_runtime_azure" "synapse_integration_runtime_azure" {
  for_each = var.synapse_workspace_integration_runtimes

  name                 = each.key
  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  location             = azurerm_synapse_workspace.synapse_workspace.location

  compute_type     = each.value.compute_type
  core_count       = each.value.core_count
  description      = "Azure Integration Runtime."
  time_to_live_min = each.value.time_to_live_min
}

# SQL pools
resource "azurerm_synapse_sql_pool" "sql_pool" {
  for_each = var.synapse_workspace_sql_pools

  synapse_workspace_id = azurerm_synapse_workspace.synapse_workspace.id
  name                 = each.key
  tags                 = var.tags

  create_mode               = "Default"
  collation                 = each.value.collation
  geo_backup_policy_enabled = true
  data_encrypted            = "true"
  sku_name                  = each.value.sku_name

  timeouts {
    create = "40m"
  }
}

resource "azapi_update_resource" "sql_pool_maintenance_windows" {
  for_each = var.synapse_workspace_sql_pools

  type      = "Microsoft.Synapse/workspaces/sqlPools/maintenancewindows@2021-06-01"
  parent_id = azurerm_synapse_sql_pool.sql_pool[each.key].id
  name      = "current"

  body = jsonencode({
    properties = {

      timeRanges = [for maintenance_window in var.synapse_workspace_sql_pool_maintenance_windows :
        {
          dayOfWeek = maintenance_window.day_of_week
          duration  = maintenance_window.duration
          startTime = maintenance_window.start_time
        }
      ]
    }
  })
}
