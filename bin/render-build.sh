#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies excluding development and test gems
bundle install --without development test

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run database migrations
bundle exec rails db:migrate
