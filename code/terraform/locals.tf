locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  subnet = {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }

  default_machine_learning_workspace_image_builder_compute_name = "imagebuilder001"
  default_machine_learning_workspace_outbound_rules = {
    # Required pypi dependencies to be able to install libraries
    "pypi001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "pypi.org"
      status      = "Active"
    },
    "pypi002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "pythonhosted.org"
      status      = "Active"
    },
    "pypi003" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.pythonhosted.org"
      status      = "Active"
    },
    "pypi004" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "pypi.python.org"
      status      = "Active"
    },
    "anaconda001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "anaconda.com"
      status      = "Active"
    },
    "anaconda002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.anaconda.com"
      status      = "Active"
    },
    "anaconda003" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.anaconda.org"
      status      = "Active"
    },
    "r001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "cloud.r-project.org"
      status      = "Active"
    },
    "pytorch001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "pytorch.org"
      status      = "Active"
    },
    "pytorch002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.pytorch.org"
      status      = "Active"
    },
    "tensorflow001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.tensorflow.org"
      status      = "Active"
    },
    # Required for VSCode features. Dependencies are documented here: https://code.visualstudio.com/docs/setup/network#_common-hostnames
    "vscode001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "update.code.visualstudio.com"
      status      = "Active"
    },
    "vscode002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vo.msecnd.net"
      status      = "Active"
    },
    "vscode003" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "marketplace.visualstudio.com"
      status      = "Active"
    },
    "vscode004" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vscode.blob.core.windows.net"
      status      = "Active"
    },
    "vscode005" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.gallerycdn.vsassets.io"
      status      = "Active"
    },
    "vscode006" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "raw.githubusercontent.com" // "/microsoft/vscode-tools-for-ai/master/azureml_remote_websocket_server/*"
      status      = "Active"
    },
    "vscode007" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscode.dev"
      status      = "Active"
    },
    "vscode008" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscode-cdn.net"
      status      = "Active"
    },
    "vscode009" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscodeexperiments.azureedge.net"
      status      = "Active"
    },
    "vscode010" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "default.exp-tas.com"
      status      = "Active"
    },
    "vscode011" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "code.visualstudio.com"
      status      = "Active"
    },
    "vscode012" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.gallery.vsassets.io"
      status      = "Active"
    },
    "vscode013" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vscode.search.windows.net"
      status      = "Active"
    },
    "vscode014" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vsmarketplacebadges.dev"
      status      = "Active"
    },
    "vscode015" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vscode.download.prss.microsoft.com"
      status      = "Active"
    },
    "vscode016" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "download.visualstudio.microsoft.com"
      status      = "Active"
    },
    "vscode017" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vscode-sync.trafficmanager.net"
      status      = "Active"
    },
    "vscode018" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vscode.dev"
      status      = "Active"
    },
    "vscode019" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscode-unpkg.net"
      status      = "Active"
    },
    "maven001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.maven.org"
      status      = "Active"
    },
    # Required for some prompt flow features where this public storage account is being used which is owned by Azure Open AI
    "openai001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "openaipublic.blob.core.windows.net"
      status      = "Active"
    },
    "docker001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "docker.io"
      status      = "Active"
    },
    "docker002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.docker.io"
      status      = "Active"
    },
    "docker003" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.docker.com"
      status      = "Active"
    },
    "docker004" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "production.cloudflare.docker.com"
      status      = "Active"
    },
    "docker005" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "cdn.auth0.com"
      status      = "Active"
    },
    "azure001" = {
      type        = "ServiceTag"
      category    = "UserDefined"
      destination = "AzureOpenDatasets"
      status      = "Active"
    },
    "huggingface001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "cdn-lfs.huggingface.co"
      status      = "Active"
    },
    "${azurerm_storage_account.storage.name}-table" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_storage_account.storage.id
        subresourceTarget = "table"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    },
    "${azurerm_storage_account.storage.name}-queue" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_storage_account.storage.id
        subresourceTarget = "queue"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
    # ,
    # "${azurerm_storage_account.storage.name}-blob" = {
    #   type     = "PrivateEndpoint"
    #   category = "UserDefined"
    #   status   = "Active"
    #   destination = {
    #     serviceResourceId = azurerm_storage_account.storage.id
    #     subresourceTarget = "blob"
    #     sparkEnabled      = true
    #     sparkStatus       = "Active"
    #   }
    # }
  }
  search_service_machine_learning_workspace_outbound_rules = {
    "${var.search_service_enabled ? azurerm_search_service.search_service[0].name : ""}-searchService" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = var.search_service_enabled ? azurerm_search_service.search_service[0].id : ""
        subresourceTarget = "searchService"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  open_ai_machine_learning_workspace_outbound_rules = {
    "${var.open_ai_enabled ? azurerm_cognitive_account.cognitive_account[0].name : ""}-account" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = var.open_ai_enabled ? azurerm_cognitive_account.cognitive_account[0].id : ""
        subresourceTarget = "account"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  cognitive_accounts_machine_learning_workspace_outbound_rules = {
    for key, value in var.cognitive_services :
    "${azurerm_cognitive_account.cognitive_accounts[key].name}-account" => {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_cognitive_account.cognitive_accounts[key].id
        subresourceTarget = "account"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  machine_learning_workspace_outbound_rules = merge(local.default_machine_learning_workspace_outbound_rules, var.search_service_enabled ? local.search_service_machine_learning_workspace_outbound_rules : {}, var.open_ai_enabled ? local.open_ai_machine_learning_workspace_outbound_rules : {}, local.cognitive_accounts_machine_learning_workspace_outbound_rules)
}
