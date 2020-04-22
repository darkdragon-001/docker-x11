#!/bin/bash
# every exit != 0 fails the script
set -e

# generate container user
source /generate_container_user

# correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

# execute user command
exec "$@"

