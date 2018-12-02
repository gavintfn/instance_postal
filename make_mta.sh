#!/bin/bash

set -e

#
# Dependencies
#
apt update
apt install -y software-properties-common
apt-add-repository ppa:brightbox/ruby-ng -y
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu xenial main'
curl -sL https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -
add-apt-repository 'deb http://www.rabbitmq.com/debian/ testing main'
apt update
export DEBIAN_FRONTEND=noninteractive
apt install -y ruby2.3 ruby2.3-dev build-essential mariadb-server libmysqlclient-dev rabbitmq-server nodejs git nginx wget nano
gem install bundler procodile --no-rdoc --no-ri

#
# MySQL
#
echo 'CREATE DATABASE `postal` CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;' | mysql -u root
echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "XXXMYSQL_ROOT_PASSWORDXXX";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "XXXMYSQL_ROOT_PASSWORDXXX";' | mysql -u root
echo 'GRANT ALL ON `postal`.* TO `postal`@`localhost` IDENTIFIED BY "XXXMYSQL_ROOT_PASSWORDXXX";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`localhost`  IDENTIFIED BY "XXXMYSQL_ROOT_PASSWORDXXX";' | mysql -u root
echo 'GRANT ALL ON *.* TO `root`@`%` IDENTIFIED BY "XXXMYSQL_ROOT_PASSWORDXXX";' | mysql -u root

#
# RabbitMQ
#
rabbitmqctl add_vhost /postal
rabbitmqctl add_user postal "XXXMYSQL_ROOT_PASSWORDXXX"
rabbitmqctl set_permissions -p /postal postal ".*" ".*" ".*"

#
# System prep
#
useradd -r -m -d /opt/postal -s /bin/bash postal
setcap 'cap_net_bind_service=+ep' /usr/bin/ruby2.3

#
# Application Setup
#
sudo -i -u postal mkdir -p /opt/postal/app
wget https://postal.atech.media/packages/stable/latest.tgz -O - | sudo -u postal tar zxpv -C /opt/postal/app
ln -s /opt/postal/app/bin/postal /usr/bin/postal
postal bundle /opt/postal/vendor/bundle
postal initialize-config
