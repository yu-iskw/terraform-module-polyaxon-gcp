## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| available\_scopes | GCP scopes | `list(string)` | n/a | yes |
| cluster\_name | Kubernetes cluster name | `string` | n/a | yes |
| gcp\_project | GCP project ID | `string` | n/a | yes |
| gcp\_zone | GCP zone | `string` | n/a | yes |
| gpu\_node\_pools | A list of GPU node pool definitions | <pre>list(object({<br>    min_node_count = number<br>    max_node_count = number<br>    machine_type   = string<br>    guest_accelerator = object({<br>      type  = string<br>      count = number<br>    })<br>  }))</pre> | n/a | yes |
| is\_preemptible | preemptible or not | `bool` | n/a | yes |
| disk\_size\_gb | Disk size in GB | `number` | `1024` | no |
| disk\_type | Disk type ('pd-standard' or 'pd-ssd') | `string` | `"pd-standard"` | no |
| polyaxon\_label | Polyaxon label | `string` | `"experiments"` | no |

## Outputs

| Name | Description |
|------|-------------|
| node\_pools | Lists of node pool names and labels |

