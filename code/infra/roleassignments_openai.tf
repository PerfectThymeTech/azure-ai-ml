resource "azurerm_role_assignment" "cognitive_account_openai_role_assignment_storage_blob_contributor" {
  count = var.open_ai_enabled ? 1 : 0

  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account_openai[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "cognitive_account_openai_role_assignment_search_index_data_reader" {
  count = var.open_ai_enabled && var.search_service_enabled ? 1 : 0

  scope                = azurerm_search_service.search_service[0].id
  role_definition_name = "Search Index Data Reader"
  principal_id         = azurerm_cognitive_account.cognitive_account_openai[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "cognitive_account_openai_role_assignment_search_service_contributor" {
  count = var.open_ai_enabled && var.search_service_enabled ? 1 : 0

  scope                = azurerm_search_service.search_service[0].id
  role_definition_name = "Search Service Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account_openai[0].identity[0].principal_id
}
