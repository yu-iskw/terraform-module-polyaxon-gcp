# Credentials for kubernetes provider
variable "kubernetes_config_path" {
  type        = string
  description = "Path to the file of kubernetes credentials config"
}

#
# Basic GCP settings
#
variable "gcp_project" {
  type        = string
  description = "GCP project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP region"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone"
}

variable "gke_cluster_name" {
  type        = string
  description = "GKE Cluster name"
}

#
# Polyaxon
#
variable "polyaxon_version" {
  type        = string
  description = "Polyaxon version"
  default     = "0.6.1"
}

variable "install_polyaxon" {
  type        = string
  description = "Flag to install polyaxon (it should be no, manual or auto)"
  default     = "no"
}

variable "polyaxon_config_template_path" {
  type        = string
  description = "Path to the template of polyaxon config"
  default     = null
}

#
# IAM
#
variable "polyaxon_users" {
  type        = list(string)
  description = "A list of google account emails of polyaxon users"
  default     = []
}

#
# GKE of polyaxon cluster
#
variable "polyaxon_core_node_pool" {
  type = object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
    disk_size_gb   = number
  })
  description = "Node pool configuration for polyaxon core"
  default = {
    min_node_count = 3
    max_node_count = 5
    machine_type   = "n1-standard-4"
    disk_size_gb   = 256
  }
}

variable "polyaxon_builds_node_pool" {
  type = object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
    disk_size_gb   = number
  })
  description = "Node pool configuration for polyaxon builds"
  default = {
    min_node_count = 1
    max_node_count = 3
    machine_type   = "n1-standard-4"
    disk_size_gb   = 512
  }
}

variable "regular_cpu_experiments_node_pool" {
  type = list(object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
  }))
  description = "Regular CPU instance node pools for polyaxon experiments"
  default     = []
}

variable "preemptible_cpu_experiments_node_pools" {
  type = list(object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
  }))
  description = "Regular CPU instance node pools for polyaxon experiments"
  default     = []
}

variable "regular_gpu_experiments_node_pools" {
  type = list(object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
    guest_accelerator = object({
      type  = string
      count = number
    })
  }))
  description = "A list of GPU node pool definitions for polyaxon experiments"
  default     = []
}

variable "preemptible_gpu_experiments_node_pools" {
  type = list(object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
    guest_accelerator = object({
      type  = string
      count = number
    })
  }))
  description = "A list of GPU node pool definitions for polyaxon experiments"
  default     = []
}

variable "disk_type_experiments" {
  type        = string
  description = "disk_type of a node for polyaxon experiments ('pd-standard' or 'pd-ssd')"
  default     = "pd-standard"
}

variable "disk_size_gb_experiments" {
  type        = number
  description = "disk_size_gb of a node for polyaxon experiments"
  default     = 1024
}

# SEE ALSO: https://cloud.google.com/sdk/gcloud/reference/container/clusters/create#--scopes
variable "available_scopes" {
  type        = list(string)
  description = "Available GCP scopes of node pool for polyaxon"
  default = [
    # 'default' scope
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/pubsub",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",

    # 'bigquery' scope
    "https://www.googleapis.com/auth/bigquery",

    # 'cloud-platform' scope
    "https://www.googleapis.com/auth/cloud-platform",

    # 'storage-full' scope
    "https://www.googleapis.com/auth/devstorage.full_control",

    # 'monitoring'
    "https://www.googleapis.com/auth/monitoring",
  ]
}

#
# GCS
#
variable "bucket_outputs" {
  type = object({
    storage_class        = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE
    age                  = number
    action_type          = string # Delete or SetStorageClass
    action_storage_class = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE
    force_destroy        = bool
  })
  description = "Attributes of GCS bucket for polyaxon outputs"
  default = {
    storage_class        = "REGIONAL"
    age                  = 90
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = true
  }
}

variable "bucket_data" {
  type = object({
    storage_class        = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE
    age                  = number
    action_type          = string # Delete or SetStorageClass
    action_storage_class = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE
    force_destroy        = bool
  })
  description = "Attributes of GCS bucket for polyaxon data"
  default = {
    storage_class        = "REGIONAL"
    age                  = 90
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = true
  }
}

variable "bucket_logs" {
  type = object({
    storage_class        = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE
    age                  = number
    action_type          = string # Delete or SetStorageClass
    action_storage_class = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE
    force_destroy        = bool
  })
  description = "Attributes of GCS bucket for polyaxon logs"
  default = {
    storage_class        = "REGIONAL"
    age                  = 90
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = true
  }
}


#
# Cloud SQL
#
variable "sql_name" {
  type        = string
  description = "Cloud SQL instance name for polyaxon"
  default     = "polyaxon-postgres"
}

variable "sql_disk_size_gb" {
  type        = number
  description = "Cloud SQL disk size in GB"
  default     = 256
}

variable "sql_settings_tier" {
  type        = string
  description = "Cloud SQL machine type"
  default     = "db-custom-2-8192"
}

#
# Network
#
variable "private_network_name" {
  type        = string
  description = "GCP private network name"
  default     = "polyaxon-private-network"
}

#
# Cloud Filestore
#
variable "filestore_core" {
  type = object({
    capacity_gb = number
    tier        = string
  })
  description = "capacity_gb of the core Cloud Filestore"
  default = {
    capacity_gb = 1024
    tier        = "STANDARD"
  }
}

# If users want to add extra Cloud Filestore, the variable enables them to add.
variable "filestore_extras" {
  type = list(object({
    capacity_gb = number
    tier        = string # STANDARD or PREMIUM
  }))
  description = "A list of extra Cloud Filestore"
  default     = []
}

#
# Memorystore
#
variable "memorystore_enabled" {
  type        = bool
  description = "Flag to use Cloud MemoryStore"
  default     = false
}

variable "memorystore_size_gb" {
  type        = number
  description = "Memory size of Cloud MemoryStore in GB"
  default     = 3
}

variable "kubernetes_enabled" {
  type        = bool
  description = "Kubernetes"
  default     = false
}
