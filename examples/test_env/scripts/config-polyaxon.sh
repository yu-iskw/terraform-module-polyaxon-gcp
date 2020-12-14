#!/bin/bash
set -e

# Set the configurations.
HOST=${1:-localhost}
HTTP_PORT=31811
polyaxon config set --host="${HOST}" --port=${HTTP_PORT}

# Show the configurations
polyaxon config --list
