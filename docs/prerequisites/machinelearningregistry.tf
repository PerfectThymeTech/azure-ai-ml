resource "azapi_resource" "machine_learning_registry" {
  type      = "Microsoft.MachineLearningServices/registries@2023-10-01"
  parent_id = azurerm_resource_group.resource_group_ml_registry.id
  name      = "${local.prefix}-mlreg001"
  location  = var.location
  tags      = var.tags
  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    properties = {
      publicNetworkAccess = "Disabled"
      regionDetails = [
        {
          location = var.location
          acrDetails = [
            {
              systemCreatedAcrAccount = {
                acrAccountSku = "Premium"
              }
              userCreatedAcrAccount = null
            }
          ]
          storageAccountDetails = [
            {
              systemCreatedStorageAccount = {
                allowBlobPublicAccess    = false
                storageAccountHnsEnabled = false
                storageAccountType       = "Standard_GRS"
              }
              userCreatedStorageAccount = null
            }
          ]
        }
      ]
    }
  })

  response_export_values = ["*"]
}

resource "azurerm_private_endpoint" "machine_learning_registry_private_endpoint" {
  name                = "${azapi_resource.machine_learning_registry.name}-amlregistry-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_ml_registry.name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.machine_learning_registry.name}-amlregistry-nic"
  private_service_connection {
    name                           = "${azapi_resource.machine_learning_registry.name}-amlregistry-pe"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.machine_learning_registry.id
    subresource_names              = ["amlregistry"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_machine_learning_api == "" ? [] : [1]
    content {
      name = "${azapi_resource.machine_learning_registry.name}-amlregistry-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_machine_learning_api
      ]
    }
  }
}

resource "azurerm_private_endpoint" "machine_learning_registry_private_endpoint_blob" {
  name                = "${azapi_resource.machine_learning_registry.name}-blob-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_ml_registry.name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.machine_learning_registry.name}-blob-nic"
  private_service_connection {
    name                           = "${azapi_resource.machine_learning_registry.name}-blob-pe"
    is_manual_connection           = false
    private_connection_resource_id = jsondecode(azapi_resource.machine_learning_registry.output).properties.regionDetails[0].storageAccountDetails[0].systemCreatedStorageAccount.armResourceId.resourceId
    subresource_names              = ["blob"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_blob == "" ? [] : [1]
    content {
      name = "${azapi_resource.machine_learning_registry.name}-blob-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_blob
      ]
    }
  }
}

resource "azurerm_private_endpoint" "machine_learning_registry_private_endpoint_registry" {
  name                = "${azapi_resource.machine_learning_registry.name}-registry-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_ml_registry.name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.machine_learning_registry.name}-registry-nic"
  private_service_connection {
    name                           = "${azapi_resource.machine_learning_registry.name}-registry-pe"
    is_manual_connection           = false
    private_connection_resource_id = jsondecode(azapi_resource.machine_learning_registry.output).properties.regionDetails[0].acrDetails[0].systemCreatedAcrAccount.armResourceId.resourceId
    subresource_names              = ["registry"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_container_registry == "" ? [] : [1]
    content {
      name = "${azapi_resource.machine_learning_registry.name}-registry-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_container_registry
      ]
    }
  }
}
