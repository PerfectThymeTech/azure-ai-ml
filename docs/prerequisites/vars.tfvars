# General variables
location           = "northeurope"
location_secondary = "westeurope"
environment        = "dev"
prefix             = "dpmlr"
tags               = {}

# ML variables

# Network variables
subnet_id                                = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-logic-network-rg/providers/Microsoft.Network/virtualNetworks/mycrp-prd-logic-vnet001/subnets/PeSubnet"
private_dns_zone_id_blob                 = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
private_dns_zone_id_container_registry   = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
private_dns_zone_id_machine_learning_api = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
