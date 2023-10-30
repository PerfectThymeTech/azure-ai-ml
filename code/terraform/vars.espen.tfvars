location               = "eastus"
environment            = "dev"
prefix                 = "mbtst003"
tags                   = {}
resource_group_name    = "mabuss-aml-tst"
subnet_id              = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/virtualNetworks/mynetwork002/subnets/default"
open_ai_enabled        = true
search_service_enabled = false
machine_learning_compute_clusters = {
  # "cpu001" = {
  #   vm_priority = "Dedicated"
  #   vm_size     = "Standard_DS2_v2"
  #   scale = {
  #     min_node_count                       = 0
  #     max_node_count                       = 3
  #     scale_down_nodes_after_idle_duration = "PT30S"
  #   }
  # }
}
machine_learning_compute_instances = {
  # "mabuss" = {
  #   vm_size        = "Standard_DS2_v2"
  #   user_object_id = "540d8186-5d32-4ab6-a962-0d91ba5bd2c2"
  # }
}
private_dns_zone_id_blob                       = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
private_dns_zone_id_file                       = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
private_dns_zone_id_table                      = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
private_dns_zone_id_queue                      = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
private_dns_zone_id_container_registry         = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
private_dns_zone_id_key_vault                  = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
private_dns_zone_id_machine_learning_api       = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
private_dns_zone_id_machine_learning_notebooks = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
private_dns_zone_id_search_service             = "/subscriptions/506db2d3-06b6-40bd-a4f2-c2b11ec29b74/resourceGroups/global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"
data_platform_subscription_ids                 = []
