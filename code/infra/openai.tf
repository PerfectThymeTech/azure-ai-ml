resource "azurerm_cognitive_account" "cognitive_account_openai" {
  count = var.open_ai_enabled ? 1 : 0

  name                = "${local.prefix}-aoai001"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name      = "${local.prefix}-cog001"
  dynamic_throttling_enabled = false
  fqdns = var.search_service_enabled ? [
    trimsuffix(replace(azurerm_storage_account.storage.primary_blob_endpoint, "https://", ""), "/"),
    "${azurerm_search_service.search_service[0].name}.search.windows.net"
    ] : [
    trimsuffix(replace(azurerm_storage_account.storage.primary_blob_endpoint, "https://", ""), "/"),
  ]
  kind               = "OpenAI"
  local_auth_enabled = true
  network_acls {
    default_action = "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = true
  public_network_access_enabled      = true
  sku_name                           = "S0"
}

resource "azapi_update_resource" "cognitive_account_update" {
  count = var.open_ai_enabled ? 1 : 0

  type        = "Microsoft.CognitiveServices/accounts@2023-10-01-preview"
  resource_id = azurerm_cognitive_account.cognitive_account_openai[0].id

  body = jsonencode({
    properties = {
      networkAcls = {
        bypass = "AzureServices"
      }
    }
  })
}

resource "azapi_resource" "cognitive_service_open_ai_model_ada" {
  count = var.open_ai_enabled ? 1 : 0

  type      = "Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview"
  name      = "text-embedding-ada-002"
  parent_id = azurerm_cognitive_account.cognitive_account_openai[0].id

  body = jsonencode({
    sku = {
      name     = "Standard"
      capacity = 60
    }
    properties = {
      model = {
        format  = "OpenAI"
        name    = "text-embedding-ada-002"
        version = "2"
      }
      raiPolicyName        = "Microsoft.Default"
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
  })
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_cognitive_service" {
  count = var.open_ai_enabled ? 1 : 0

  resource_id = azurerm_cognitive_account.cognitive_account_openai[0].id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_cognitive_service" {
  count = var.open_ai_enabled ? 1 : 0

  name                       = "logAnalytics"
  target_resource_id         = azurerm_cognitive_account.cognitive_account_openai[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service[0].log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service[0].metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "cognitive_service_private_endpoint" {
  count = var.open_ai_enabled ? 1 : 0

  name                = "${azurerm_cognitive_account.cognitive_account_openai[0].name}-pe"
  location            = var.location
  resource_group_name = azurerm_cognitive_account.cognitive_account_openai[0].resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_cognitive_account.cognitive_account_openai[0].name}-nic"
  private_service_connection {
    name                           = "${azurerm_cognitive_account.cognitive_account_openai[0].name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.cognitive_account_openai[0].id
    subresource_names              = ["account"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_open_ai == "" ? [] : [1]
    content {
      name = "${azurerm_cognitive_account.cognitive_account_openai[0].name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_open_ai
      ]
    }
  }
}
