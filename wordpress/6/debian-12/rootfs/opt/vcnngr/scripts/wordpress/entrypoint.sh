#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load WordPress environment
. /opt/vcnngr/scripts/wordpress-env.sh

# Load libraries
. /opt/vcnngr/scripts/
. /opt/vcnngr/scripts/liblog.sh
. /opt/vcnngr/scripts/libwebserver.sh

print_welcome_page

if [[ "$1" = "/opt/vcnngr/scripts/$(web_server_type)/run.sh" || "$1" = "/opt/vcnngr/scripts/nginx-php-fpm/run.sh" ]]; then
    info "** Starting WordPress setup **"
    /opt/vcnngr/scripts/"$(web_server_type)"/setup.sh
    /opt/vcnngr/scripts/php/setup.sh
    /opt/vcnngr/scripts/mysql-client/setup.sh
    /opt/vcnngr/scripts/wordpress/setup.sh
    /post-init.sh
    info "** WordPress setup finished! **"
fi

echo ""
exec "$@"
