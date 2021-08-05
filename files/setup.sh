#!/bin/bash

set -euo pipefail
set -x

cn=${1:-webserver}

gcsfuse_repo=gcsfuse-$(lsb_release -c -s)
export GCSFUSE_REPO=$gcsfuse_repo
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | \
  tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  apt-key add -

mkdir -p /etc/ssl/nginx
openssl req -x509 -nodes \
  -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl//nginx/webserver.key \
  -out /etc/ssl/nginx/webserver.crt \
  -subj "/C=BR/ST=SantaCatarina/L=BalnearioArroioDoSilva/O=Org/CN=$cn"

apt update -y 
apt install -y nginx gcsfuse


cat << EOF > /etc/nginx/conf.d/ssl.conf
      server {
        listen 443 ssl;
        ssl_certificate /etc/ssl/nginx/webserver.crt;
        ssl_certificate_key /etc/ssl/nginx/webserver.key;
      }
EOF

systemctl enable nginx
systemctl restart nginx
