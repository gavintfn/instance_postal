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
/usr/bin/perl -pi -e  "s/bind-address/#bind-address/g" /etc/mysql/my.cnf
echo 'CREATE DATABASE `postal` CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;' | mysql -u root
echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "p0stalpassw0rd";' | mysql -u root
echo 'GRANT ALL ON `postal`.* TO `postal`@`localhost` IDENTIFIED BY "p0stalpassw0rd";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "p0stalpassw0rd";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`localhost`  IDENTIFIED BY "p0stalpassw0rd";' | mysql -u root

#
# RabbitMQ
#
rabbitmqctl add_vhost /postal
rabbitmqctl add_user postal p0stalpassw0rd
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
postal initialize
postal start





#
# nginx
#
cp /opt/postal/app/resource/nginx.cfg /etc/nginx/sites-available/default
#usr/bin/perl -pi -e  "s/postal.yourdomain.com/YYYFQDNYYY/g"  /etc/nginx/sites-available/default
/bin/mkdir /etc/nginx/ssl/
openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/postal.key -out /etc/nginx/ssl/postal.cert -days 365 -nodes -subj "/C=GB/ST=Example/L=Example/O=Example/CN=example.com"
service nginx reload

#/usr/bin/printf "$ADMIN_EMAIL\n$ADMIN_FIRSTNAME\n$ADMIN_LASTNAME\n$ADMIN_PASSWORD" | /usr/bin/postal make-user

#wget https://raw.githubusercontent.com/gavintfn/instance_postal/master/postal.yml.bk 
#cp postal.yml.bk /opt/postal/config/postal.yml.bk
#/bin/grep "secret" /opt/postal/config/postal.yml >> /opt/postal/config/postal.yml.bk
#cp /opt/postal/config/postal.yml /opt/postal/config/postal.yml.bkbk
#rm /opt/postal/config/postal.yml -f
#cp /opt/postal/config/postal.yml.bk /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXFQDNXXX/YYYFQDNYYY/g" /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXMYSQL_ROOT_PASSWORDXXX/YYYMYSQL_ROOT_PASSWORDYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXRABBITMQ_PASSWORDXXX/YYYRABBITMQ_PASSWORDYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXSMTP_PORTXXX/YYYSMTP_PORTYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXHOSTNAMEXXX/YYYHOSTNAMEYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXADMIN_EMAILXXX/YYYADMIN_EMAILYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXADMIN_PASSWORDXXX/YYYADMIN_PASSWORDYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXHOSTNAMEXXX/YYYHOSTNAMEYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXIPADDRXXX/YYYIPADDRYYY/g"  /opt/postal/config/postal.yml
#/usr/bin/perl -pi -e  "s/XXXADMIN_USERNAMEXXX/YYYADMIN_USERNAMEYYY/g"  /opt/postal/config/postal.yml

#rabbitmqctl change_password postal YYYMYSQL_ROOT_PASSWORDYYY
#echo "SET PASSWORD FOR 'postal'@'127.0.0.1' = PASSWORD('YYYMYSQL_ROOT_PASSWORDYYY');" | mysql -u root
#echo "SET PASSWORD FOR 'postal'@'localhost' = PASSWORD('YYYMYSQL_ROOT_PASSWORDYYY');" | mysql -u root
#echo 'GRANT ALL ON *.* TO `root`@`%` IDENTIFIED BY "YYYMYSQL_ROOT_PASSWORDYYY";' | mysql -u root
#echo 'FLUSH PRIVILEGES;' | mysql -u root
#postal restart


