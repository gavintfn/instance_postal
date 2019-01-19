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
echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "YYYMYSQL_ROOT_PASSWORDYYY";' | mysql -u root
echo 'GRANT ALL ON `postal`.* TO `postal`@`localhost` IDENTIFIED BY "YYYMYSQL_ROOT_PASSWORDYYY";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "YYYMYSQL_ROOT_PASSWORDYYY";' | mysql -u root
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`localhost`  IDENTIFIED BY "YYYMYSQL_ROOT_PASSWORDYYY";' | mysql -u root

#
# RabbitMQ
#
rabbitmqctl add_vhost /postal
rabbitmqctl add_user postal YYYMYSQL_ROOT_PASSWORDYYY
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
#chown postal:postal /opt/postal -R
wget https://postal.atech.media/packages/stable/latest.tgz -O - | sudo -u postal tar zxpv -C /opt/postal/app
rm /opt/postal/app/config/postal.example.yml
wget https://raw.githubusercontent.com/gavintfn/postal/master/spec/config/postal.yml -O /opt/postal/app/config/postal.example.yml
#cp postal.yml /opt/postal/app/config/postal.example.yml

#chown postal:postal /opt/postal/ -R
#cd /opt/postal
#sudo -i -u postal wget https://github.com/gavintfn/postal/archive/master.zip
#sudo -i -u postal unzip master.zip
#sudo -i -u postal cp /opt/postal/postal-master/* /opt/postal/ -R


/usr/bin/perl -pi -e  "s/XXXFQDNXXX/YYYFQDNYYY/g" /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXMYSQL_ROOT_PASSWORDXXX/YYYMYSQL_ROOT_PASSWORDYYY/g"  /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXRABBITMQ_PASSWORDXXX/YYYRABBITMQ_PASSWORDYYY/g"  /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXSMTP_PORTXXX/YYYSMTP_PORTYYY/g"  /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXHOSTNAMEXXX/YYYHOSTNAMEYYY/g"  /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXADMIN_EMAILXXX/YYYADMIN_EMAILYYY/g"  /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXADMIN_PASSWORDXXX/YYYADMIN_PASSWORDYYY/g" /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXHOSTNAMEXXX/YYYHOSTNAMEYYY/g" /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXIPADDRXXX/YYYIPADDRYYY/g"  /opt/postal/app/config/postal.example.yml
/usr/bin/perl -pi -e  "s/XXXADMIN_USERNAMEXXX/YYYADMIN_USERNAMEYYY/g"  /opt/postal/app/config/postal.example.yml

chown postal:postal /opt/postal/app/config/postal.example.yml

ln -s /opt/postal/app/bin/postal /usr/bin/postal
postal bundle /opt/postal/vendor/bundle
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('YYYMYSQL_ROOT_PASSWORDYYY'); SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('YYYMYSQL_ROOT_PASSWORDYYY'); GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'YYYMYSQL_ROOT_PASSWORDYYY'; FLUSH PRIVILEGES;" | mysql -u root
sudo -i -u postal postal initialize-config
sudo -i -u postal postal initialize
sudo -i -u postal postal start





#
# nginx
#
cp /opt/postal/app/resource/nginx.cfg /etc/nginx/sites-available/default
#usr/bin/perl -pi -e  "s/postal.yourdomain.com/YYYFQDNYYY/g"  /etc/nginx/sites-available/default
/bin/mkdir /etc/nginx/ssl/
openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/postal.key -out /etc/nginx/ssl/postal.cert -days 365 -nodes -subj "/C=GB/ST=Example/L=Example/O=Example/CN=example.com"
service nginx reload

service mysql restart

#
#add db info
#
echo "USE postal; INSERT INTO credentials (credentials.`server_id`, credentials.`key`,credentials`type`,credentials.`name`) VALUES (1,'YYYADMIN_PASSWORDYYY','SMTP','YYYADMIN_USERNAMEYYY');" | mysql -u root -p'YYYMYSQL_ROOT_PASSWORDYYY'
echo "USE postal; INSERT INTO organizations (organizations.`id`, organizations.`uuid`, organizations.`name`, organizations.`permalink`, organizations.`time_zone`, organizations.`created_at`, organizations.`updated_at`, organizations.`owner_id`) VALUES (1, 'YYYORGANIZATION_UUIDYYY', 'YYYORGANIZATIONYYY', 'YYYORGANIZATION_PERMALINKYYY', 'UTC', NOW(), NOW(), 1);" | mysql -u root -p'YYYMYSQL_ROOT_PASSWORDYYY'
echo "USE postal; INSERT INTO servers(servers.`id`, servers.`organization_id`, servers.`uuid`, servers.`name`, servers.`mode`, servers.`created_at`, servers.`updated_at`, servers.`permalink`, servers.`message_retention_days`, servers.`raw_message_retention_days`, servers.`raw_message_retention_size`, servers.`allow_sender`, servers.`token`, servers.`spam_threshold`, servers`spam_failure_threshold`, servers.`postmaster_address`, servers.`log_smtp_data`) VALUES (1, 1, 'YYYMAILSERVER_UUIDYYY', 'YYYMAILSERVER_NAMEYYY', 'Live',  NOW(), NOW(), 'YYYMAILSERVER_PERMALINKYYY', 60, 30, 2048, 0, 'l2ui3d', 5.00, 20.00, 'YYYPOSTMASTERYYY', 0); " | mysql -u root -p'YYYMYSQL_ROOT_PASSWORDYYY'




#/usr/bin/printf "$ADMIN_EMAIL\n$ADMIN_FIRSTNAME\n$ADMIN_LASTNAME\n$ADMIN_PASSWORD" | /usr/bin/postal make-user

#wget https://raw.githubusercontent.com/gavintfn/instance_postal/master/postal.yml.bk 
#cp postal.yml.bk /opt/postal/config/postal.yml.bk
#/bin/grep "secret" /opt/postal/config/postal.yml >> /opt/postal/config/postal.yml.bk
#cp /opt/postal/config/postal.yml /opt/postal/config/postal.yml.bkbk
#rm /opt/postal/config/postal.yml -f
#cp /opt/postal/config/postal.yml.bk /opt/postal/config/postal.yml


#rabbitmqctl change_password postal YYYMYSQL_ROOT_PASSWORDYYY
#echo "SET PASSWORD FOR 'postal'@'127.0.0.1' = PASSWORD('YYYMYSQL_ROOT_PASSWORDYYY');" | mysql -u root
#echo "SET PASSWORD FOR 'postal'@'localhost' = PASSWORD('YYYMYSQL_ROOT_PASSWORDYYY');" | mysql -u root
#echo 'GRANT ALL ON *.* TO `root`@`%` IDENTIFIED BY "YYYMYSQL_ROOT_PASSWORDYYY";' | mysql -u root
#echo 'FLUSH PRIVILEGES;' | mysql -u root
#postal restart


