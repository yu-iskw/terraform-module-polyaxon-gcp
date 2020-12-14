#!/bin/bash
set -e

gcp_project=${1:-personal-project}
cluster_name=${2:-polyaxon}

gcloud container clusters get-credentials "${cluster_name}" \
    --zone us-central1-b \
    --project "${gcp_project}"
