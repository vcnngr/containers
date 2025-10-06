#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/vcnngr/scripts/libmariadbgalera.sh

# Load MariaDB environment variables
. /opt/vcnngr/scripts/mariadb-env.sh

mysql_healthcheck
