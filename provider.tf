provider "random" {
  version = "~> 2.0"
}

provider "google" {
  version = "~> 3.27"

  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

provider "kubernetes" {
  version = "~> 1.11"

  load_config_file = true
  config_path      = var.kubernetes_config_path
  config_context   = "gke_${var.gcp_project}_${var.gcp_zone}_${var.gke_cluster_name}"
}

provider "helm" {
  version         = "~> 0.9"
  namespace       = "polyaxon"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.13.0"
  init_helm_home  = true
  debug           = true
  service_account = "tiller"

  kubernetes {
    load_config_file = true
    config_context   = "gke_${var.gcp_project}_${var.gcp_zone}_${var.gke_cluster_name}"
  }
}
