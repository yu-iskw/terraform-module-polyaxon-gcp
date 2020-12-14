variable "gcp_project" {
  type        = string
  description = "GCP project ID"
}

variable "kubernetes_config_context" {
  type        = string
  description = "Kubernetes config context. We can see them with `kubectl config get-contexts`"
}
