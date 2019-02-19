#!/usr/bin/env bash
NGINX='nginx'
PHP='php'
echo 开始检查是否安装${NGINX}

function LOG() {
    echo "=========================$1========================="
}

#kill 进程id
function kill_pid() {
    echo "Kill程序:$1"
    sudo ps -ef|grep $1|grep -v grep|awk '{print $2}'|xargs kill -9
}

#删除文件
function delete_file() {
    echo "删除文件:$1"
    _delete=`sudo find / -name $1`
    echo "搜索到的文件$_delte"
    for i in  ; do
        rm -rf $i
    done
}

LOG "安装${NGINX}"
function install_nginx() {
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
    nginx_version=`nginx -v`
    echo ${NGINX}当前版本${nginx_version}
}

if [`command -v ${NGINX}`]; then
    nginx_version=`nginx -v`
    echo ${NGINX}当前版本${nginx_version}
    echo "是否卸载${NGINX}(y or n)"
    read flag
    echo 开始卸载Nginx版本
    if [ ${flag}="y" -o ${flag}="Y" ]; then
        echo 开始卸载${NGINX}
        uninstall=`sudo apt-get --purge remove nginx \
                   sudo apt-get autoremove \
                   sudo apt-get --purge remove nginx \
                   sudo apt-get --purge remove nginx-common \
                   sudo apt-get --purge remove nginx-core`
        delete_file ${NGINX}
        kill_pid ${NGINX}
    else
        exit
    fi
fi
echo 开始重装Nginx
install_nginx
echo 启动${NGINX}
sudo /etc/init.d/nginx start
echo 启动${NGINX}成功

LOG "安装${PHP}"
function install_php() {
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get udpate
    sudo apt-get install php php-fpm php-mysql php-xml php-gd -y
    php_version=`nginx -v`
    echo ${PHP}当前版本${php_version}
}

if [`command -v ${PHP}`]; then
    php_version=`php -v`
    echo ${PHP}当前版本${nginx_version}
    echo "是否卸载${PHP}(y or n)"
    read flag
    echo 开始卸载PHP版本
    if [ ${flag}="y" -o ${flag}="Y" ]; then
        echo 开始卸载${PHP}
        uninstall=`sudo apt-get autoremove php*`
        delete_file ${PHP}
        kill_pid ${PHP}
    else
        exit
    fi
fi
install_php
echo "启动PHP请输入php版本（php7.0-fpm）"
read php_version
sudo service ${php_version} start
echo 启动${PHP}成功