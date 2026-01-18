#!/bin/bash
set -euo pipefail

# Load environment variables. Required so that the PostgreSQL related variables are available:
# - POSTGRES_HOST
# - POSTGRES_PORT
# - POSTGRES_DB
# - POSTGRES_USER
source .env

