#!/bin/bash
set -e

bundle check || bundle install --jobs 3

bundle exec rails db:migrate

exec "$@"
