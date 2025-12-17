#!/usr/bin/env sh
set -e

cd "${DBT_PROJECT_DIR}"

# Install packages if applicable (safe to run repeatedly)
if [ -f packages.yml ]; then
  dbt deps --quiet || dbt deps
fi

exec "$@"
