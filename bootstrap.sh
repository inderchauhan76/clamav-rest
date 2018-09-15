#!/bin/bash

service ssh start

# This is a new bootstrap for the combined container that will call the bootstrap in the
# mkodockx/docker-clamav container and than starts the clamav-rest application.

set -m

host=${CLAMD_HOST:-0.0.0.0}
port=${CLAMD_PORT:-3310}

service ssh start

echo "using clamd server: $host:$port"

/bootstrap.sh & 

# start in background
java -jar /var/clamav-rest/clamav-rest-1.0.2.jar --clamd.host=$host --clamd.port=$port
