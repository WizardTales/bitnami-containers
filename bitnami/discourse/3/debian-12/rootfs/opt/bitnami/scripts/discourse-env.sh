#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for discourse

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-discourse}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
discourse_env_vars=(
    DISCOURSE_SERVE_STATIC_ASSETS
    DISCOURSE_DATA_TO_PERSIST
    DISCOURSE_ENABLE_HTTPS
    DISCOURSE_EXTERNAL_HTTP_PORT_NUMBER
    DISCOURSE_EXTERNAL_HTTPS_PORT_NUMBER
    DISCOURSE_HOST
    DISCOURSE_PORT_NUMBER
    DISCOURSE_SKIP_BOOTSTRAP
    DISCOURSE_SITE_NAME
    DISCOURSE_ENV
    DISCOURSE_PRECOMPILE_ASSETS
    DISCOURSE_ENABLE_CONF_PERSISTENCE
    DISCOURSE_EXTRA_CONF_CONTENT
    DISCOURSE_PASSENGER_SPAWN_METHOD
    DISCOURSE_PASSENGER_EXTRA_FLAGS
    DISCOURSE_USERNAME
    DISCOURSE_PASSWORD
    DISCOURSE_EMAIL
    DISCOURSE_FIRST_NAME
    DISCOURSE_LAST_NAME
    DISCOURSE_SMTP_HOST
    DISCOURSE_SMTP_PORT_NUMBER
    DISCOURSE_SMTP_USER
    DISCOURSE_SMTP_PASSWORD
    DISCOURSE_SMTP_PROTOCOL
    DISCOURSE_SMTP_AUTH
    DISCOURSE_SMTP_OPEN_TIMEOUT
    DISCOURSE_SMTP_READ_TIMEOUT
    DISCOURSE_DATABASE_HOST
    DISCOURSE_DATABASE_PORT_NUMBER
    DISCOURSE_DATABASE_NAME
    DISCOURSE_DATABASE_USER
    DISCOURSE_DATABASE_PASSWORD
    DISCOURSE_DB_BACKUP_HOST
    DISCOURSE_DB_BACKUP_PORT
    DISCOURSE_REDIS_HOST
    DISCOURSE_REDIS_PORT_NUMBER
    DISCOURSE_REDIS_PASSWORD
    DISCOURSE_REDIS_USE_SSL
    DISCOURSE_HOSTNAME
    DISCOURSE_SKIP_INSTALL
    SMTP_HOST
    SMTP_PORT
    DISCOURSE_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    SMTP_AUTH
    POSTGRESQL_HOST
    POSTGRESQL_PORT_NUMBER
    DISCOURSE_POSTGRESQL_NAME
    DISCOURSE_POSTGRESQL_USERNAME
    DISCOURSE_POSTGRESQL_PASSWORD
    REDIS_HOST
    REDIS_PORT_NUMBER
    REDIS_PASSWORD
    REDIS_USE_SSL
)
for env_var in "${discourse_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset discourse_env_vars

# Paths
export DISCOURSE_BASE_DIR="${BITNAMI_ROOT_DIR}/discourse"
export DISCOURSE_CONF_FILE="${DISCOURSE_BASE_DIR}/config/discourse.conf"
export PATH="${BITNAMI_ROOT_DIR}/common/bin:${BITNAMI_ROOT_DIR}/brotli/bin:${BITNAMI_ROOT_DIR}/git/bin:${PATH}"
export YARN_CACHE_FOLDER="${DISCOURSE_BASE_DIR}/tmp/cache"

# Discourse persistence configuration
DISCOURSE_SERVE_STATIC_ASSETS="${DISCOURSE_SERVE_STATIC_ASSETS:-true}"
export DISCOURSE_SERVE_STATIC_ASSETS="${DISCOURSE_SERVE_STATIC_ASSETS:-true}"
export DISCOURSE_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/discourse"
export DISCOURSE_DATA_TO_PERSIST="${DISCOURSE_DATA_TO_PERSIST:-plugins public/backups public/uploads}"

# System users (when running with a privileged user)
export DISCOURSE_DAEMON_USER="discourse"
export DISCOURSE_DAEMON_GROUP="discourse"

# Discourse configuration
export DISCOURSE_ENABLE_HTTPS="${DISCOURSE_ENABLE_HTTPS:-no}"
export DISCOURSE_EXTERNAL_HTTP_PORT_NUMBER="${DISCOURSE_EXTERNAL_HTTP_PORT_NUMBER:-80}"
export DISCOURSE_EXTERNAL_HTTPS_PORT_NUMBER="${DISCOURSE_EXTERNAL_HTTPS_PORT_NUMBER:-443}"
DISCOURSE_HOST="${DISCOURSE_HOST:-"${DISCOURSE_HOSTNAME:-}"}"
export DISCOURSE_HOST="${DISCOURSE_HOST:-www.example.com}"
export DISCOURSE_PORT_NUMBER="${DISCOURSE_PORT_NUMBER:-3000}"
DISCOURSE_SKIP_BOOTSTRAP="${DISCOURSE_SKIP_BOOTSTRAP:-"${DISCOURSE_SKIP_INSTALL:-}"}"
export DISCOURSE_SKIP_BOOTSTRAP="${DISCOURSE_SKIP_BOOTSTRAP:-}" # only used during the first initialization
export DISCOURSE_SITE_NAME="${DISCOURSE_SITE_NAME:-My site!}" # only used during the first initialization
export DISCOURSE_ENV="${DISCOURSE_ENV:-production}"
export DISCOURSE_PRECOMPILE_ASSETS="${DISCOURSE_PRECOMPILE_ASSETS:-yes}"
export DISCOURSE_ENABLE_CONF_PERSISTENCE="${DISCOURSE_ENABLE_CONF_PERSISTENCE:-no}"
export DISCOURSE_EXTRA_CONF_CONTENT="${DISCOURSE_EXTRA_CONF_CONTENT:-yes}"
export DISCOURSE_PASSENGER_SPAWN_METHOD="${DISCOURSE_PASSENGER_SPAWN_METHOD:-direct}"
export DISCOURSE_PASSENGER_EXTRA_FLAGS="${DISCOURSE_PASSENGER_EXTRA_FLAGS:-}"

# Discourse credentials
export DISCOURSE_USERNAME="${DISCOURSE_USERNAME:-user}" # only used during the first initialization
export DISCOURSE_PASSWORD="${DISCOURSE_PASSWORD:-bitnami123}" # only used during the first initialization
export DISCOURSE_EMAIL="${DISCOURSE_EMAIL:-user@example.com}" # only used during the first initialization
export DISCOURSE_FIRST_NAME="${DISCOURSE_FIRST_NAME:-UserName}" # only used during the first initialization
export DISCOURSE_LAST_NAME="${DISCOURSE_LAST_NAME:-LastName}" # only used during the first initialization

# Discourse SMTP credentials
DISCOURSE_SMTP_HOST="${DISCOURSE_SMTP_HOST:-"${SMTP_HOST:-}"}"
export DISCOURSE_SMTP_HOST="${DISCOURSE_SMTP_HOST:-}"
DISCOURSE_SMTP_PORT_NUMBER="${DISCOURSE_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
DISCOURSE_SMTP_PORT_NUMBER="${DISCOURSE_SMTP_PORT_NUMBER:-"${DISCOURSE_SMTP_PORT:-}"}"
export DISCOURSE_SMTP_PORT_NUMBER="${DISCOURSE_SMTP_PORT_NUMBER:-}"
DISCOURSE_SMTP_USER="${DISCOURSE_SMTP_USER:-"${SMTP_USER:-}"}"
export DISCOURSE_SMTP_USER="${DISCOURSE_SMTP_USER:-}"
DISCOURSE_SMTP_PASSWORD="${DISCOURSE_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export DISCOURSE_SMTP_PASSWORD="${DISCOURSE_SMTP_PASSWORD:-}"
DISCOURSE_SMTP_PROTOCOL="${DISCOURSE_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export DISCOURSE_SMTP_PROTOCOL="${DISCOURSE_SMTP_PROTOCOL:-}"
DISCOURSE_SMTP_AUTH="${DISCOURSE_SMTP_AUTH:-"${SMTP_AUTH:-}"}"
export DISCOURSE_SMTP_AUTH="${DISCOURSE_SMTP_AUTH:-login}"
export DISCOURSE_SMTP_OPEN_TIMEOUT="${DISCOURSE_SMTP_OPEN_TIMEOUT:-}"
export DISCOURSE_SMTP_READ_TIMEOUT="${DISCOURSE_SMTP_READ_TIMEOUT:-}"

# Database configuration
export DISCOURSE_DEFAULT_DATABASE_HOST="postgresql" # only used at build time
DISCOURSE_DATABASE_HOST="${DISCOURSE_DATABASE_HOST:-"${POSTGRESQL_HOST:-}"}"
export DISCOURSE_DATABASE_HOST="${DISCOURSE_DATABASE_HOST:-$DISCOURSE_DEFAULT_DATABASE_HOST}"
DISCOURSE_DATABASE_PORT_NUMBER="${DISCOURSE_DATABASE_PORT_NUMBER:-"${POSTGRESQL_PORT_NUMBER:-}"}"
export DISCOURSE_DATABASE_PORT_NUMBER="${DISCOURSE_DATABASE_PORT_NUMBER:-5432}"
DISCOURSE_DATABASE_NAME="${DISCOURSE_DATABASE_NAME:-"${DISCOURSE_POSTGRESQL_NAME:-}"}"
export DISCOURSE_DATABASE_NAME="${DISCOURSE_DATABASE_NAME:-bitnami_discourse}"
DISCOURSE_DATABASE_USER="${DISCOURSE_DATABASE_USER:-"${DISCOURSE_POSTGRESQL_USERNAME:-}"}"
export DISCOURSE_DATABASE_USER="${DISCOURSE_DATABASE_USER:-bn_discourse}"
DISCOURSE_DATABASE_PASSWORD="${DISCOURSE_DATABASE_PASSWORD:-"${DISCOURSE_POSTGRESQL_PASSWORD:-}"}"
export DISCOURSE_DATABASE_PASSWORD="${DISCOURSE_DATABASE_PASSWORD:-}"
export DISCOURSE_DB_BACKUP_HOST="${DISCOURSE_DB_BACKUP_HOST:-$DISCOURSE_DATABASE_HOST}"
export DISCOURSE_DB_BACKUP_PORT="${DISCOURSE_DB_BACKUP_PORT:-$DISCOURSE_DATABASE_PORT_NUMBER}"

# Redis configuration
export DISCOURSE_DEFAULT_REDIS_HOST="redis" # only used at build time
DISCOURSE_REDIS_HOST="${DISCOURSE_REDIS_HOST:-"${REDIS_HOST:-}"}"
export DISCOURSE_REDIS_HOST="${DISCOURSE_REDIS_HOST:-$DISCOURSE_DEFAULT_REDIS_HOST}"
DISCOURSE_REDIS_PORT_NUMBER="${DISCOURSE_REDIS_PORT_NUMBER:-"${REDIS_PORT_NUMBER:-}"}"
export DISCOURSE_REDIS_PORT_NUMBER="${DISCOURSE_REDIS_PORT_NUMBER:-6379}"
DISCOURSE_REDIS_PASSWORD="${DISCOURSE_REDIS_PASSWORD:-"${REDIS_PASSWORD:-}"}"
export DISCOURSE_REDIS_PASSWORD="${DISCOURSE_REDIS_PASSWORD:-}"
DISCOURSE_REDIS_USE_SSL="${DISCOURSE_REDIS_USE_SSL:-"${REDIS_USE_SSL:-}"}"
export DISCOURSE_REDIS_USE_SSL="${DISCOURSE_REDIS_USE_SSL:-no}"

# Custom environment variables may be defined below
