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

if [[ $# < 2 ]] ; then
    echo 'Usage: '$0' <ORCHESTRATOR_IP> <ADMIN_PASSWD>'
    exit 1
fi

set -e

ORCHESTRATOR_IP=$1
ADMIN_PASSWD=$2

yum -y update && yum -y upgrade
yum -y install wget firewalld
yum -y install python-backports-ssl_match_hostname python-setuptools python-backports
yum clean all
rm -rf /var/cache/yum

## Cloudify Manager 18.2.1
#wget -q http://repository.cloudifysource.org/cloudify/18.2.1/community-release/cloudify-manager-install-community-18.2.1.rpm

## Cloudify Manager 18.2.28
wget http://repository.cloudifysource.org/cloudify/18.2.28/community-release/cloudify-manager-install-community-18.2.28.rpm

## Install Cloudify CLI package
rpm -Uvh cloudify-manager-install-community-*.rpm
rm cloudify-manager-install-community-*.rpm

## cfy manager installation
cfy_manager install --private-ip $ORCHESTRATOR_IP --public-ip $ORCHESTRATOR_IP --admin-password $ADMIN_PASSWD

## Configure firewall
firewall-cmd --zone=public --add-service=ssh
firewall-cmd --zone=public --permanent --add-service=ssh
firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --add-service=https
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --zone=public --add-port=5671/tcp
firewall-cmd --zone=public --permanent --add-port=5671/tcp
firewall-cmd --zone=public --add-port=53229/tcp
firewall-cmd --zone=public --permanent --add-port=53229/tcp
firewall-cmd --zone=public --add-port=53333/tcp
firewall-cmd --zone=public --permanent --add-port=53333/tcp
##cluster_ports
#firewall-cmd --zone=public --add-service=8300/tcp
#firewall-cmd --zone=public --permanent --add-service=8300/tcp
#firewall-cmd --zone=public --add-service=8301/tcp
#firewall-cmd --zone=public --permanent --add-service=8301/tcp
#firewall-cmd --zone=public --add-port=8500/tcp
#firewall-cmd --zone=public --permanent --add-port=8500/tcp
#firewall-cmd --zone=public --add-port=15432/tcp
#firewall-cmd --zone=public --permanent --add-port=15432/tcp
#firewall-cmd --zone=public --add-port=22000/tcp
#firewall-cmd --zone=public --permanent --add-port=22000/tcp

systemctl enable firewalld
systemctl start firewalld
