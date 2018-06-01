#!/bin/bash

# Copyright 2018 MSO4SC - javier.carnero@atos.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# Import our environment variables from systemd
for e in $(tr "\000" "\n" < /proc/1/environ); do
    eval "export $e"
done

abort () {
  echo "$@" >&2
  exit 1
}

if [ -z "$ORCHESTRATOR_IP" ]; then
    abort "ERROR: no ORCHESTRATOR_IP specified in docker-compose.yml"
fi

if [ -z "$ADMIN_PASSWD" ]; then
    abort "ERROR: no ADMIN_PASSWD specified in docker-compose.yml"
fi

CONTAINER_IP=$(getent hosts $(hostname) | awk '{print $1}')

cfy_manager install --private-ip $CONTAINER_IP --public-ip $ORCHESTRATOR_IP --admin-password $ADMIN_PASSWD
#only install once
systemctl disable install_manager

#if [ -f /etc/cloudify/.install ]; then
#    cfy_manager configure --private-ip $CONTAINER_IP --public-ip $ORCHESTRATOR_IP --admin-password $ADMIN_PASSWD
#else
#    cfy_manager install --private-ip $CONTAINER_IP --public-ip $ORCHESTRATOR_IP --admin-password $ADMIN_PASSWD
#fi
