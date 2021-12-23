#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.

rm -f /test_app/tmp/pids/unicorn.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"