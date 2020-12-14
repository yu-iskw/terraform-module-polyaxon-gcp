variable "gcp_project" {
  type        = string
  description = "GCP project ID"
  default     = "personal-project"
}

variable "kubernetes_config_context" {
  type        = string
  description = "Kubernetes config context. We can see them with `kubectl config get-contexts`"
  default     = "gke_personal-project_us-central1-b_polyaxon-cluster"
}

variable "install_polyaxon" {
  type        = bool
  description = "Flag to install polyaxon or not"
  default     = false
}

