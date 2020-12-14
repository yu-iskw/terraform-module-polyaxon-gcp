## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcp\_project | GCP project ID | `string` | n/a | yes |
| gcp\_region | GCP region | `string` | n/a | yes |
| gcp\_zone | GCP zone | `string` | n/a | yes |
| gke\_cluster\_name | GKE Cluster name | `string` | n/a | yes |
| kubernetes\_config\_path | Path to the file of kubernetes credentials config | `string` | n/a | yes |
| available\_scopes | Available GCP scopes of node pool for polyaxon | `list(string)` | <pre>[<br>  "https://www.googleapis.com/auth/devstorage.read_only",<br>  "https://www.googleapis.com/auth/logging.write",<br>  "https://www.googleapis.com/auth/monitoring.write",<br>  "https://www.googleapis.com/auth/pubsub",<br>  "https://www.googleapis.com/auth/service.management.readonly",<br>  "https://www.googleapis.com/auth/servicecontrol",<br>  "https://www.googleapis.com/auth/trace.append",<br>  "https://www.googleapis.com/auth/bigquery",<br>  "https://www.googleapis.com/auth/cloud-platform",<br>  "https://www.googleapis.com/auth/devstorage.full_control",<br>  "https://www.googleapis.com/auth/monitoring"<br>]</pre> | no |
| bucket\_data | Attributes of GCS bucket for polyaxon data | <pre>object({<br>    storage_class        = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE<br>    age                  = number<br>    action_type          = string # Delete or SetStorageClass<br>    action_storage_class = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE<br>    force_destroy        = bool<br>  })</pre> | <pre>{<br>  "action_storage_class": "NEARLINE",<br>  "action_type": "SetStorageClass",<br>  "age": 90,<br>  "force_destroy": true,<br>  "storage_class": "REGIONAL"<br>}</pre> | no |
| bucket\_logs | Attributes of GCS bucket for polyaxon logs | <pre>object({<br>    storage_class        = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE<br>    age                  = number<br>    action_type          = string # Delete or SetStorageClass<br>    action_storage_class = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE<br>    force_destroy        = bool<br>  })</pre> | <pre>{<br>  "action_storage_class": "NEARLINE",<br>  "action_type": "SetStorageClass",<br>  "age": 90,<br>  "force_destroy": true,<br>  "storage_class": "REGIONAL"<br>}</pre> | no |
| bucket\_outputs | Attributes of GCS bucket for polyaxon outputs | <pre>object({<br>    storage_class        = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE<br>    age                  = number<br>    action_type          = string # Delete or SetStorageClass<br>    action_storage_class = string # MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE<br>    force_destroy        = bool<br>  })</pre> | <pre>{<br>  "action_storage_class": "NEARLINE",<br>  "action_type": "SetStorageClass",<br>  "age": 90,<br>  "force_destroy": true,<br>  "storage_class": "REGIONAL"<br>}</pre> | no |
| disk\_size\_gb\_experiments | disk\_size\_gb of a node for polyaxon experiments | `number` | `1024` | no |
| disk\_type\_experiments | disk\_type of a node for polyaxon experiments ('pd-standard' or 'pd-ssd') | `string` | `"pd-standard"` | no |
| filestore\_core | capacity\_gb of the core Cloud Filestore | <pre>object({<br>    capacity_gb = number<br>    tier        = string<br>  })</pre> | <pre>{<br>  "capacity_gb": 1024,<br>  "tier": "STANDARD"<br>}</pre> | no |
| filestore\_extras | A list of extra Cloud Filestore | <pre>list(object({<br>    capacity_gb = number<br>    tier        = string # STANDARD or PREMIUM<br>  }))</pre> | `[]` | no |
| install\_polyaxon | Flag to install polyaxon (it should be no, manual or auto) | `string` | `"no"` | no |
| kubernetes\_enabled | Kubernetes | `bool` | `false` | no |
| memorystore\_enabled | Flag to use Cloud MemoryStore | `bool` | `false` | no |
| memorystore\_size\_gb | Memory size of Cloud MemoryStore in GB | `number` | `3` | no |
| polyaxon\_builds\_node\_pool | Node pool configuration for polyaxon builds | <pre>object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>    disk_size_gb   = number<br>  })</pre> | <pre>{<br>  "disk_size_gb": 512,<br>  "machine_type": "n1-standard-4",<br>  "max_node_count": 3,<br>  "min_node_count": 1<br>}</pre> | no |
| polyaxon\_config\_template\_path | Path to the template of polyaxon config | `string` | `null` | no |
| polyaxon\_core\_node\_pool | Node pool configuration for polyaxon core | <pre>object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>    disk_size_gb   = number<br>  })</pre> | <pre>{<br>  "disk_size_gb": 256,<br>  "machine_type": "n1-standard-4",<br>  "max_node_count": 5,<br>  "min_node_count": 3<br>}</pre> | no |
| polyaxon\_users | A list of google account emails of polyaxon users | `list(string)` | `[]` | no |
| polyaxon\_version | Polyaxon version | `string` | `"0.6.1"` | no |
| preemptible\_cpu\_experiments\_node\_pools | Regular CPU instance node pools for polyaxon experiments | <pre>list(object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>  }))</pre> | `[]` | no |
| preemptible\_gpu\_experiments\_node\_pools | A list of GPU node pool definitions for polyaxon experiments | <pre>list(object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>    guest_accelerator = object({<br>      type  = string<br>      count = number<br>    })<br>  }))</pre> | `[]` | no |
| private\_network\_name | GCP private network name | `string` | `"polyaxon-private-network"` | no |
| regular\_cpu\_experiments\_node\_pool | Regular CPU instance node pools for polyaxon experiments | <pre>list(object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>  }))</pre> | `[]` | no |
| regular\_gpu\_experiments\_node\_pools | A list of GPU node pool definitions for polyaxon experiments | <pre>list(object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>    guest_accelerator = object({<br>      type  = string<br>      count = number<br>    })<br>  }))</pre> | `[]` | no |
| sql\_disk\_size\_gb | Cloud SQL disk size in GB | `number` | `256` | no |
| sql\_name | Cloud SQL instance name for polyaxon | `string` | `"polyaxon-postgres"` | no |
| sql\_settings\_tier | Cloud SQL machine type | `string` | `"db-custom-2-8192"` | no |

