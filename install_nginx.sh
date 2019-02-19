#!/bin/bash
apt-get update
apt-get -y install nginx
NIGINX_PATH=/etc/nginx
CONFIG_FILE=gate-way
touch ${NIGINX_PATH}/sites-available/${CONFIG_FILE}
cat >> ${NIGINX_PATH}/sites-available/${CONFIG_FILE} << EOF
server {
    listen       80;
    server_name  oall.xyz www.oall.xyz;

    location / {
        proxy_pass http://45.63.123.250:8081;
    }

    location /api {
        proxy_pass http://45.63.123.250:8080;
    }

    location /static {
        proxy_pass http://45.76.96.73:8081;
    }
}

server {
    listen       80;
    server_name  manager.oall.xyz;

    location / {
        proxy_pass http://45.77.134.149:8081;
    }

    location /api {
        proxy_pass http://45.77.134.149:8080;
    }
}

server {
    listen       9090;
    server_name  _;

    location /api {
        proxy_pass http://45.76.96.73:8080;
    }
}

server {
    listen       80;
    server_name  mx.oall.xyz;

    location / {
        proxy_pass http://127.0.0.1:8841;
    }
}
EOF
ln -s ${NIGINX_PATH}/sites-available/${CONFIG_FILE} ${NIGINX_PATH}/sites-enabled/${CONFIG_FILE}
/etc/init.d/nginx start
