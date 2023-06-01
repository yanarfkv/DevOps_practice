#!/usr/bin/env bash

# Install all dependencies
composer install -n

# Run possible migrations, so that database is always up to date
bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration

exec "$@"