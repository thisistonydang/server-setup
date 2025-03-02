#!/bin/bash
set -euo pipefail

# Load environment variables. Required so that the USERNAME variable is available.
source .env

# Only create a new user if one doesn't already exist.
if id "${USERNAME}" &>/dev/null; then
    echo "User '${USERNAME}' already exists."
else
fi
