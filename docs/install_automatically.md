# Automatically install polyaxon with terraform
This document describes how to build the GCP environment for polyaxon.

1. Create module with `install_polyaxon=true`

## 1. Create module with `install_polyaxon=true`
Since the module install polyaxon with the helm provider, all we have to do is to execute `terraform apply`.
```bash
$ terraform init
$ terraform apply
```
