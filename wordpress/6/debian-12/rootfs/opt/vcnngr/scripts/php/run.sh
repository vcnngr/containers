#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/vcnngr/scripts/libphp.sh
. /opt/vcnngr/scripts/liblog.sh

# Load PHP-FPM environment variables
. /opt/vcnngr/scripts/php-env.sh

info "** Starting PHP-FPM **"
declare -a args=("--pid" "$PHP_FPM_PID_FILE" "--fpm-config" "$PHP_FPM_CONF_FILE" "-c" "$PHP_CONF_DIR" "-F")
exec "${PHP_FPM_SBIN_DIR}/php-fpm" "${args[@]}"
