# General variables
variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "location_openai" {
  description = "Specifies the location for Azure Open AI."
  type        = string
  sensitive   = false
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["dev", "tst", "qa", "prd"], var.environment)
    error_message = "Please use an allowed value: \"dev\", \"tst\", \"qa\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "resource_group_name" {
  description = "Specifies the name of the resource group in which all resources will be deployed."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid resource group name."
  }
}

# ML variables
variable "machine_learning_compute_clusters" {
  type = map(object({
    vm_priority = optional(string, "Dedicated")
    vm_size     = optional(string, "Standard_DS2_v2")
    scale = object({
      min_node_count                       = optional(any, 0)
      max_node_count                       = optional(any, 3)
      scale_down_nodes_after_idle_duration = optional(string, "PT60S")
    })
  }))
  sensitive   = false
  default     = {}
  description = "Specifies the compute cluster to be created for the Machine Learning Workspace."
  validation {
    condition = alltrue([
      length([for vm_priority in values(var.machine_learning_compute_clusters)[*].vm_priority : vm_priority if !contains(["LowPriority", "Dedicated"], vm_priority)]) <= 0
    ])
    error_message = "Please specify a compute cluster configuration."
  }
}

variable "machine_learning_compute_instances" {
  type = map(object({
    user_object_id = string
    vm_size        = optional(string, "Standard_DS2_v2")
  }))
  sensitive   = false
  default     = {}
  description = "Specifies the compute instances to be created for the Machine Learning Workspace."
  # validation {
  #   condition = alltrue([
  #     length([for vm_priority in values(var.machine_learning_compute_clusters)[*].vm_priority : vm_priority if !contains(["LowPriority", "Dedicated"], vm_priority)]) <= 0
  #   ])
  #   error_message = "Please specify a compute instance configuration."
  # }
}

# Service enablement variables
variable "search_service_enabled" {
  description = "Specifies whether Azure Cognitive Search should be deployed."
  type        = bool
  sensitive   = false
  default     = false
}

variable "open_ai_enabled" {
  description = "Specifies whether Azure Open AI should be deployed."
  type        = bool
  sensitive   = false
  default     = false
}

variable "cognitive_services" {
  type = map(object({
    kind     = string
    sku_name = optional(string, "S0")
  }))
  sensitive   = false
  default     = {}
  description = "Specifies the cognitive services deployed for this use-case."
  validation {
    condition = alltrue([
      length([for kind in values(var.cognitive_services)[*].kind : kind if !contains(["Academic", "AnomalyDetector", "Bing.Autosuggest", "Bing.Autosuggest.v7", "Bing.CustomSearch", "Bing.Search", "Bing.Search.v7", "Bing.Speech", "Bing.SpellCheck", "Bing.SpellCheck.v7", "CognitiveServices", "ComputerVision", "ContentModerator", "CustomSpeech", "CustomVision.Prediction", "CustomVision.Training", "Emotion", "Face", "FormRecognizer", "ImmersiveReader", "LUIS", "LUIS.Authoring", "MetricsAdvisor", "Personalizer", "QnAMaker", "Recommendations", "SpeakerRecognition", "Speech", "SpeechServices", "SpeechTranslation", "TextAnalytics", "TextTranslation", "WebLM"], kind)]) <= 0,
      length([for sku_name in values(var.cognitive_services)[*].sku_name : sku_name if !contains(["F0", "F1", "S0", "S", "S1", "S2", "S3", "S4", "S5", "S6", "P0", "P1", "P2", "E0", "DC0"], sku_name)]) <= 0
    ])
    error_message = "Please specify a compute instance configuration."
  }
}

# Network variables
variable "subnet_id" {
  description = "Specifies the resource ID of the subnet used for the Private Endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

# DNS variables
variable "private_dns_zone_id_container_registry" {
  description = "Specifies the resource ID of the private DNS zone for the container registry. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_container_registry == "" || (length(split("/", var.private_dns_zone_id_container_registry)) == 9 && endswith(var.private_dns_zone_id_container_registry, "privatelink.azurecr.io"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_key_vault" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_key_vault == "" || (length(split("/", var.private_dns_zone_id_key_vault)) == 9 && endswith(var.private_dns_zone_id_key_vault, "privatelink.vaultcore.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_machine_learning_api" {
  description = "Specifies the resource ID of the private DNS zone for the Purview account. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_machine_learning_api == "" || (length(split("/", var.private_dns_zone_id_machine_learning_api)) == 9 && endswith(var.private_dns_zone_id_machine_learning_api, "privatelink.api.azureml.ms"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_machine_learning_notebooks" {
  description = "Specifies the resource ID of the private DNS zone for the Purview account. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_machine_learning_notebooks == "" || (length(split("/", var.private_dns_zone_id_machine_learning_notebooks)) == 9 && endswith(var.private_dns_zone_id_machine_learning_notebooks, "privatelink.notebooks.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_file" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage file endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_file == "" || (length(split("/", var.private_dns_zone_id_file)) == 9 && endswith(var.private_dns_zone_id_file, "privatelink.file.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_table" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage table endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_table == "" || (length(split("/", var.private_dns_zone_id_table)) == 9 && endswith(var.private_dns_zone_id_table, "privatelink.table.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_queue" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_queue == "" || (length(split("/", var.private_dns_zone_id_queue)) == 9 && endswith(var.private_dns_zone_id_queue, "privatelink.queue.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_search_service" {
  description = "Specifies the resource ID of the private DNS zone for Azure Cognitive Search endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_search_service == "" || (length(split("/", var.private_dns_zone_id_search_service)) == 9 && endswith(var.private_dns_zone_id_search_service, "privatelink.search.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_open_ai" {
  description = "Specifies the resource ID of the private DNS zone for Azure Open AI endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_open_ai == "" || (length(split("/", var.private_dns_zone_id_open_ai)) == 9 && endswith(var.private_dns_zone_id_open_ai, "privatelink.openai.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_cognitive_services" {
  description = "Specifies the resource ID of the private DNS zone for Azure Cognitive Service endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_cognitive_services == "" || (length(split("/", var.private_dns_zone_id_cognitive_services)) == 9 && endswith(var.private_dns_zone_id_cognitive_services, "privatelink.cognitiveservices.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_monitor" {
  description = "Specifies the resource ID of the private DNS zone for Azure Monitor. Not required if DNS A-records get created via Azue Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_monitor == "" || (length(split("/", var.private_dns_zone_id_monitor)) == 9 && endswith(var.private_dns_zone_id_monitor, "privatelink.monitor.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_oms_opinsights" {
  description = "Specifies the resource ID of the private DNS zone for Azure Monitor OMS Insights. Not required if DNS A-records get created via Azue Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_oms_opinsights == "" || (length(split("/", var.private_dns_zone_id_oms_opinsights)) == 9 && endswith(var.private_dns_zone_id_oms_opinsights, "privatelink.oms.opinsights.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_ods_opinsights" {
  description = "Specifies the resource ID of the private DNS zone for Azure Monitor ODS Insights. Not required if DNS A-records get created via Azue Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_ods_opinsights == "" || (length(split("/", var.private_dns_zone_id_ods_opinsights)) == 9 && endswith(var.private_dns_zone_id_ods_opinsights, "privatelink.ods.opinsights.azure.com"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_automation_agents" {
  description = "Specifies the resource ID of the private DNS zone for Azure Monitor Automation Agents. Not required if DNS A-records get created via Azue Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_automation_agents == "" || (length(split("/", var.private_dns_zone_id_automation_agents)) == 9 && endswith(var.private_dns_zone_id_automation_agents, "privatelink.agentsvc.azure-automation.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Other resources
variable "data_platform_subscription_ids" {
  description = "Specifies the list of subscription IDs of your data platform."
  type        = list(string)
  sensitive   = false
  default     = []
}
