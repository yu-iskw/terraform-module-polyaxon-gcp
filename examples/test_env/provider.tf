data "google_client_config" "current" {
}

terraform {
  required_version = "~> 0.12.3"

  backend "gcs" {
    bucket = "personal-project-terraform"
    prefix = "state/test_env"
  }
}

provider "random" {
  version = "~> 2.0"
}

provider "google" {
  version = "~> 2.20"
  project = var.gcp_project
}

provider "google-beta" {
  version = "~> 2.20"
  project = var.gcp_project
}

provider "kubernetes" {
  alias   = "kubernetes_provider"
  version = "~> 1.10"

  load_config_file = true
  config_context   = var.kubernetes_config_context

  # SEE ALSO: https://stackoverflow.com/questions/57843340/how-to-pass-gke-credential-to-kubernetes-provider-with-terraform
  // load_config_file       = false
  // host                   = "https://${module.test-polyaxon-env.gke_cluster.endpoint}"
  // cluster_ca_certificate = base64decode(module.test-polyaxon-env.gke_cluster.master_auth.0.cluster_ca_certificate)
  // token                  = data.google_client_config.current.access_token
}

provider "helm" {
  alias           = "helm_provider"
  version         = "~> 0.10.3"
  namespace       = module.test-polyaxon-env.k8s_namespace_polyaxon
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.13.0"
  install_tiller  = true
  init_helm_home  = true
  debug           = false
  service_account = module.test-polyaxon-env.k8s_service_account_tiller_name

  kubernetes {
    load_config_file = true
    config_context   = var.kubernetes_config_context

    # SEE ALSO: https://stackoverflow.com/questions/57843340/how-to-pass-gke-credential-to-kubernetes-provider-with-terraform
    // load_config_file       = false
    // host                   = "https://${module.test-polyaxon-env.gke_cluster.endpoint}"
    // cluster_ca_certificate = base64decode(module.test-polyaxon-env.gke_cluster.master_auth.0.cluster_ca_certificate)
    // token                  = data.google_client_config.current.access_token
  }
}
