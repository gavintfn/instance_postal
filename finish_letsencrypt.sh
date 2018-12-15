#!/bin/sh

/root/.acme.sh/acme.sh --issue -d XXXFQDNXXX -w /opt/postal/app/public/
sed -i 's/ssl_certificate/#ssl_certificate/g'  /etc/nginx/sites-enabled/default
sed -i 's/ssl_certificate_key/#ssl_certificate_key/g'  /etc/nginx/sites-enabled/default
sed -i 's/#certificate/ssl_certificate/g'  /etc/nginx/sites-enabled/defaultult
sed -i 's/#certificate_key/ssl_certificate_key/g'  /etc/nginx/sites-enabled/defa
/root/.acme.sh/acme.sh --install-cert -d XXXFQDNXXX --cert-file /etc/nginx/certs/XXXFQDNXXX/cert --key-file /etc/nginx/certs/XXXFQDNXXX/key --fullchain-file /etc/nginx/certs/XXXFQDNXXX/fullchain --reloadcmd "systemctl reload nginx.service"
rm /opt/postal/app/public/letsencrypt.php -f
sed -i 's/#username/username/g'  /opt/postal/config/postal.yml
sed -i 's/#password/password/g'  /opt/postal/config/postal.yml
sed -i 's/#tls_enabled/tls_enabled/g'  /opt/postal/config/postal.yml
sed -i 's/#tls_certificate_path/tls_certificate_path/g'  /opt/postal/config/postal.yml
sed -i 's/#tls_private_key_path/tls_private_key_path/g'  /opt/postal/config/postal.yml
sed -i 's/#proxy_protocol/proxy_protocol/g'  /opt/postal/config/postal.yml
sed -i 's/#log_connect/log_connect/g'  /opt/postal/config/postal.yml
sed -i 's/#host/host/g'  /opt/postal/config/postal.yml
sed -i 's/host: 127.0.0.1/#host: 127.0.0.1/g'  /opt/postal/config/postal.yml
postal restart
