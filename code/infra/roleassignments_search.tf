resource "azurerm_role_assignment" "search_role_assignment_storage_blob_contributor" {
  count = var.search_service_enabled ? 1 : 0

  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_search_service.search_service[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "search_role_assignment_storage_reader_and_data_access" {
  count = var.search_service_enabled ? 1 : 0

  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Reader and Data Access"
  principal_id         = azurerm_search_service.search_service[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "search_role_assignment_openai_contributor" {
  count = var.open_ai_enabled && var.search_service_enabled ? 1 : 0

  scope                = azurerm_cognitive_account.cognitive_account_openai[0].id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = azurerm_search_service.search_service[0].identity[0].principal_id
}
