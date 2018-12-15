#!/bin/bash

set -e

acme.sh --issue -d postal.business-perks.com -w /opt/postal/app/public/
sudo /usr/bin/perl -pi -e -i 's/ssl_certificate/#ssl_certificate/g'  /etc/nginx/sites-enabled/default
sudo /usr/bin/perl -pi -e -i "s/ssl_certificate_key/#ssl_certificate_key/g"  /etc/nginx/sites-enabled/default
sudo /usr/bin/perl -pi -e -i "s/#certificate/ssl_certificate/g"  /etc/nginx/sites-enabled/default
sudo /usr/bin/perl -pi -e -i "s/#certificate_key/ssl_certificate_key/g"  /etc/nginx/sites-enabled/default
systemctl nginx restart
acme.sh --install-cert -d XXXFQDNXXX --cert-file /etc/nginx/certs/XXXFQDNXXX/cert --key-file /etc/nginx/certs/XXXFQDNXXX/key --fullchain-file /etc/nginx/certs/XXXFQDNXXX/fullchain --reloadcmd "systemctl reload nginx.service"
