#!/bin/bash
#
# This script is used to make a SSH tunnel to the kubernetes cluster.
# Before executing the script, you have to switch the k8s cluster to polyaxon.

kubectl port-forward svc/polyaxon-polyaxon-api 31811:80 -n polyaxon
