data "google_client_config" "current" {
}

terraform {
  required_version = "~> 0.12.3"

  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "random" {
  version = "~> 2.0"
}

provider "google" {
  version = "~> 2.5"
  project = var.gcp_project
}

provider "google-beta" {
  version = "~> 2.5"
  project = var.gcp_project
}

provider "kubernetes" {
  alias   = "kubernetes_provider"
  version = "~> 1.1"

  load_config_file = true
  config_context   = var.kubernetes_config_context
}

provider "helm" {
  alias        = "helm_provider"
  version      = "~> 0.9"
  namespace    = module.basic-module-usage.k8s_namespace_polyaxon
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.13.0"
  // install_tiller  = true
  init_helm_home  = true
  debug           = true
  service_account = module.basic-module-usage.k8s_service_account_tiller_name

  kubernetes {
    load_config_file = true
    config_context   = var.kubernetes_config_context
  }
}
