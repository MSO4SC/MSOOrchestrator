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

FROM centos:centos7

LABEL maintainer="javier.carnero@atos.net"

ENV container docker

RUN yum -y update && yum -y upgrade
RUN yum install -y deltarpm
RUN yum install -y epel-release
RUN yum install -y cronie
RUN yum -y install wget ntp
RUN yum install -y initscripts sudo openssh openssh-clients openssh-server \
	systemd-sysv openssl-1.0.2k libselinux-utils logrotate java-headless \
    python-setuptools python-backports python-backports-ssl_match_hostname which
RUN yum clean all
RUN rm -rf /var/cache/yum

RUN ssh-keygen -A

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

## Cloudify Manager 18.2.28
RUN wget http://repository.cloudifysource.org/cloudify/18.2.28/community-release/cloudify-manager-install-community-18.2.28.rpm

## Install Cloudify CLI package
RUN rpm -Uvh cloudify-manager-install-community-*.rpm
RUN rm cloudify-manager-install-community-*.rpm

EXPOSE 22 80 443 5671 5672 15672 9200 5432 8086 999

ADD install_manager.service /etc/systemd/system/
ADD install_manager.sh /
RUN chmod +x /install_manager.sh

RUN systemctl enable sshd
RUN systemctl enable install_manager

ENTRYPOINT ["/usr/sbin/init"]
