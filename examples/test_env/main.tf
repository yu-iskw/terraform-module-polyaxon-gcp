locals {
  polyaxon_users = [
    "user:yu@example.com",
  ]
}


# NOTE: Cloud SQL doesn't enables us to create an instance whose name is
#       is the same as one which was deleted within 1 week.
#       So, it would be nice to provide a variable to change the name easily.
#       We are not sure if a terraform environment which wants to use the module
#       can use the random provider or not, we should not use the resources in the module.
resource "random_id" "suffix" {
  byte_length = 2
}

module "test-polyaxon-env" {
  source = "../../../terraform-module-polyaxon"

  # Polyaxon
  polyaxon_version              = "0.6.1"
  install_polyaxon              = "manual"
  polyaxon_config_template_path = "${path.cwd}/polyaxon-config.yaml.tmpl"

  # Polyaxonn developers
  polyaxon_users = local.polyaxon_users

  # GCP location
  gcp_project = var.gcp_project
  gcp_region  = "us-central1"
  gcp_zone    = "us-central1-b"

  # Network
  private_network_name = "polyaxon-network"

  # GKE
  gke_cluster_name = "test_polyaxon"

  # Cloud SQL
  sql_name = "polyaxon-sql-${random_id.suffix.dec}"

  # GKE
  disk_size_gb_experiments = 1024

  polyaxon_core_node_pool = {
    min_node_count = 3
    max_node_count = 3
    machine_type   = "n1-standard-4"
    disk_size_gb   = 64
  }

  polyaxon_builds_node_pool = {
    min_node_count = 1
    max_node_count = 3
    machine_type   = "n1-standard-4"
    disk_size_gb   = 64
  }

  regular_cpu_experiments_node_pool = [
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-32"
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-16"
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-8"
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-4"
    },
  ]

  preemptible_cpu_experiments_node_pools = [
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-32"
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-16"
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-8"
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-standard-4"
    },
  ]

  # `gcloud compute accelerator-types list` enables us to get the list of GPU types.
  regular_gpu_experiments_node_pools = [
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 1
      }
    },
  ]

  preemptible_gpu_experiments_node_pools = [
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 20
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 1
      }
    },
  ]
}
