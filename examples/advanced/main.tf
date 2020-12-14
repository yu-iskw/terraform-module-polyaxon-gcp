# NOTE: Cloud SQL doesn't enables us to create an instance whose name is
#       is the same as one which was deleted within 1 week.
#       So, it would be nice to provide a variable to change the name easily.
#       We are not sure if a terraform environment which wants to use the module
#       can use the random provider or not, we should not use the resources in the module.
resource "random_id" "suffix" {
  byte_length = 4
}

module "advanced-module-usage" {
  source = "../../../terraform-module-polyaxon"

  # GCP location
  gcp_project = var.gcp_project
  gcp_region  = "us-central1"
  gcp_zone    = "us-central1-b"

  #
  # Polyaxon
  #
  // Flag to instlal polyaxon or not
  install_polyaxon = "manual"
  // Polyaxon version
  polyaxon_version = "0.6.1"
  // Custom polyaxon configuration
  polyaxon_config_template_path = "${path.cwd}/polyaxon-config.yaml.tmpl"

  #
  # IAM
  #
  // Register IAM of polyaxon developers
  polyaxon_users = [
    "user:yu@example.com"
  ]

  # GKE
  gke_cluster_name = "advanced_example_polyaxon"

  #
  # GCS
  #
  // Configuration of polyaxon outputs buckets
  bucket_outputs = {
    storage_class        = "REGIONAL"
    age                  = 90
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = true
  }
  // Configuration of polyaxon logs buckets
  bucket_logs = {
    storage_class        = "REGIONAL"
    age                  = 90
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = true
  }
  // Configuration of polyaxon data buckets
  bucket_data = {
    storage_class        = "REGIONAL"
    age                  = 90
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = true
  }

  #
  # Cloud SQL
  #
  // Cloud SQL instance name
  sql_name = "polyaxon-sql-${random_id.suffix.id}"
  // Disk size of Cloud SQL in GB
  sql_disk_size_gb = 1
  // Cloud SQL instance type
  sql_settings_tier = "db-custom-2-8192"

  #
  # Network
  #
  private_network_name = "polyaxon-network"

  #
  # Cloud Filestore
  #
  filestore_core = {
    capacity_gb = 1024
    tier        = "STANDARD"
  }

  #
  # Memorystore
  #
  // Use external redis server of Cloud MemoryStore
  memorystore_enabled = true
  // Memory size of Cloud MemoryStore
  memorystore_size_gb = 3

  #
  # GKE
  #
  // Node pool for polyaxon core
  polyaxon_core_node_pool = {
    min_node_count = 3
    max_node_count = 5
    machine_type   = "n1-standard-4"
    disk_size_gb   = 256
  }
  // Node pool for polyaxon builds
  polyaxon_builds_node_pool = {
    min_node_count = 1
    max_node_count = 3
    machine_type   = "n1-standard-4"
    disk_size_gb   = 512
  }

  // Disk size of a node for polyaxon experiments
  disk_size_gb_experiments = 1024
  // Regular node pool with only CPU for polyaxon experiments
  regular_cpu_experiments_node_pool = [
    {
      min_node_count = 0
      max_node_count = 5
      machine_type   = "n1-standard-64"
    },
    {
      min_node_count = 0
      max_node_count = 5
      machine_type   = "n1-standard-32"
    }
  ]
  // Preemptible node pool with only CPU for polyaxon experiments
  preemptible_cpu_experiments_node_pools = [
    {
      min_node_count = 0
      max_node_count = 5
      machine_type   = "n1-standard-64"
    },
    {
      min_node_count = 0
      max_node_count = 5
      machine_type   = "n1-standard-32"
    }
  ]
  // Regular node pools with GPUs for polyaxon experiments
  regular_gpu_experiments_node_pools = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 1
      }
    },
  ]
  // Preemptible node pools with GPUs for polyaxon experiments
  preemptible_gpu_experiments_node_pools = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 1
      }
    },
  ]
}
