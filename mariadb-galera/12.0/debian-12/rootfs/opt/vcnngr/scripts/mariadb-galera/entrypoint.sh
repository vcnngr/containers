#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/vcnngr/scripts/libvcnngr.sh
. /opt/vcnngr/scripts/libmariadbgalera.sh

# Load MariaDB environment variables
. /opt/vcnngr/scripts/mariadb-env.sh

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/vcnngr/mariadb/conf)
debug "Copying files from $DB_DEFAULT_CONF_DIR to $DB_CONF_DIR"
cp -nr "$DB_DEFAULT_CONF_DIR"/. "$DB_CONF_DIR"

print_welcome_page

if [[ "$1" = "/opt/vcnngr/scripts/mariadb-galera/run.sh" ]]; then
    info "** Starting MariaDB setup **"
    /opt/vcnngr/scripts/mariadb-galera/setup.sh
    info "** MariaDB setup finished! **"
fi

echo ""
exec "$@"
