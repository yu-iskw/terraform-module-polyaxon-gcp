# Followup Setup with Polyaxon v0.6.1
We have to configure polyaxon on the web UI at polyaxon 0.6.1, since the polyaxon configuration doesn't enable us to configure everything about polyaxon.

- Get the pasword of root user
- Configure custom Node Scheduling
- Grant necessary GCP permission to the polyaxon's service account

## Get the pasword of root user
`root` is the root user of polyaxon which is the original superuser by default.
We can get the password the command below.
We can login the polyaxon web UI as `root` with the password.
```bash
# The command derives from `helm status polyaxon`.
$ kubectl get secret --namespace polyaxon polyaxon-polyaxon-secret -o jsonpath="{.data.POLYAXON_ADMIN_PASSWORD}" | base64 --decode
```

## Configure custom Node Scheduling
We can't configure custom node selectors of jobs, experiments and so on.
Instead of polyaxon configuration, we have to modify the default scheduling on the web UI so that we assign polyaxon jobs and so on to appropriate node pools respectively.
If we don't specify custom node scheduling, polyaxon jobs and so on will be assigned to any available resource.
That is, polyaxon jobs potentially run on polyaxon core and builds node pools.

- Builds Scheduling
  - URL: [Builds Scheduling](http://localhost:31811/app/settings/scheduling/builds/)
  - key: NODE_SELECTORS:BUILD_JOBS
  - value: `{"polyaxon": "builds"}`
- Jobs Scheduling
  - URL: [Jobs Scheduling](http://localhost:31811/app/settings/scheduling/jobs/)
  - key: NODE_SELECTORS:JOBS
  - value: `{"polyaxon": "experiments"}` or `{"polyaxon": "experiments-preemptible"}`
- Experiments Scheduling
  - URL: [Experiments Scheduling](http://localhost:31811/app/settings/scheduling/experiments/)
  - key: NODE_SELECTORS:EXPERIMENTS
  - value: `{"polyaxon": "experiments"}` or `{"polyaxon": "experiments-preemptible"}`
- Notebooks Scheduling
  - URL: [Notebooks Scheduling](http://localhost:31811/app/settings/scheduling/notebooks/)
  - key: NODE_SELECTORS:NOTEBOOKS
  - value: `{"polyaxon": "experiments"}`
- Tensorboards Scheduling
  - URL: [Tensorboards Scheduling](http://localhost:31811/app/settings/scheduling/tensorboards/)
  - key: NODE_SELECTORS:TENSORBOARDS
  - value: `{"polyaxon": "experiments"}`


## Cloud TPU
Unfortunately, we can specify only one Cloud TPU request resource in a polyaxon cluster with polyaxon v0.
We can specify a Cloud TPU type and version under "Setting -> Hardware Accelerators" with `K8S:TPU_TF_VERSION` and `K8S:TPU_RESOURCE_KEY` respectively.:w

- `cloud-tpus.google.com/v2`: TPU v2
- `cloud-tpus.google.com/preemptible-v2`: Preemptible TPU v2
- `cloud-tpus.google.com/v3`: TPU v3
- `cloud-tpus.google.com/preemptible-v3`: Preemptible TPU v3

There is a list of [Request a Cloud TPU in your Kubernetes Pod spec](https://cloud.google.com/tpu/docs/kubernetes-engine-setup)

## Grant necessary GCP permission to the polyaxon's service account
The module provides an terraform output `google_service_account_polyaxon` to get the service account email of polyaxon.
By registering the email to IAM in other GCP project, we can access to the resources.
For instance, we probably need to access to BigQuery in other GCP project.
We can also add `google_service_account_polyaxon` to your terraform project like [output.tf](../examples/basic/output.tf) of the basic example.
Moreover, `terraform output` enables us to get the email.
```bash
$ terraform output
...
google_service_account_polyaxon = {
  "account_id" = "polyaxon"
  "display_name" = "polyaxon"
  "email" = "polyaxon@example-project.iam.gserviceaccount.com"
}
...
```
