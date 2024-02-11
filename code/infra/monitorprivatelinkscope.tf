
resource "azurerm_monitor_private_link_scope" "mpls" {
  name                = "${local.prefix}-ampls001"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.tags
}

resource "azurerm_monitor_private_link_scoped_service" "mpls_application_insights" {
  name                = "ampls-${azurerm_application_insights.application_insights.name}"
  resource_group_name = azurerm_monitor_private_link_scope.mpls.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.mpls.name
  linked_resource_id  = azurerm_application_insights.application_insights.id
}

resource "azurerm_monitor_private_link_scoped_service" "mpls_log_analytics_workspace" {
  name                = "ampls-${azurerm_log_analytics_workspace.log_analytics_workspace.name}"
  resource_group_name = azurerm_monitor_private_link_scope.mpls.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.mpls.name
  linked_resource_id  = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

resource "azurerm_private_endpoint" "mpls_private_endpoint" {
  name                = "${azurerm_monitor_private_link_scope.mpls.name}-pe"
  location            = var.location
  resource_group_name = azurerm_monitor_private_link_scope.mpls.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_monitor_private_link_scope.mpls.name}-nic"
  private_service_connection {
    name                           = "${azurerm_monitor_private_link_scope.mpls.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_monitor_private_link_scope.mpls.id
    subresource_names              = ["azuremonitor"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  private_dns_zone_group {
    name = "${azurerm_monitor_private_link_scope.mpls.name}-arecord"
    private_dns_zone_ids = [
      var.private_dns_zone_id_monitor,
      var.private_dns_zone_id_oms_opinsights,
      var.private_dns_zone_id_ods_opinsights,
      var.private_dns_zone_id_automation_agents,
      var.private_dns_zone_id_blob
    ]
  }
}
