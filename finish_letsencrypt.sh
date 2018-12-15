#!/bin/sh

/root/.acme.sh/acme.sh --issue -d XXXFQDNXXX -w /opt/postal/app/public/
/usr/bin/perl -pi -e -i 's/ssl_certificate/#ssl_certificate/g'  /etc/nginx/sites-enabled/default
/usr/bin/perl -pi -e -i "s/ssl_certificate_key/#ssl_certificate_key/g"  /etc/nginx/sites-enabled/default
/usr/bin/perl -pi -e -i "s/#certificate/ssl_certificate/g"  /etc/nginx/sites-enabled/default
/usr/bin/perl -pi -e -i "s/#certificate_key/ssl_certificate_key/g"  /etc/nginx/sites-enabled/default
/root/.acme.sh/acme.sh --install-cert -d XXXFQDNXXX --cert-file /etc/nginx/certs/XXXFQDNXXX/cert --key-file /etc/nginx/certs/XXXFQDNXXX/key --fullchain-file /etc/nginx/certs/XXXFQDNXXX/fullchain --reloadcmd "systemctl reload nginx.service"
