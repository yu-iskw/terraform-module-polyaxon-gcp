variable "gcp_project" {
  type        = string
  description = "GCP project ID"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone"
}

variable "disk_type" {
  type        = string
  description = "Disk type ('pd-standard' or 'pd-ssd')"
  default     = "pd-standard"
}

variable "disk_size_gb" {
  type        = number
  description = "Disk size in GB"
  default     = 1024
}

variable "polyaxon_label" {
  type        = string
  description = "Polyaxon label"
  default     = "experiments"
}

variable "is_preemptible" {
  type        = bool
  description = "preemptible or not"
}

# SEE ALSO: https://cloud.google.com/sdk/gcloud/reference/container/clusters/create#--scopes
variable "available_scopes" {
  type        = list(string)
  description = "GCP scopes"
}

variable "cpu_node_pools" {
  type = list(object({
    min_node_count = number
    max_node_count = number
    machine_type   = string
  }))
  description = "A list of CPU node pool definitions"
}

