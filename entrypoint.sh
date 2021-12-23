#!/bin/bash
set -e
rm -f /test_app/tmp/pids/unicorn.pid
# Remove a potentially pre-existing server.pid for Rails.
if [ "${RAILS_ENV}" = "production" ]
then
  bundle exec rails assets:precompile
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"