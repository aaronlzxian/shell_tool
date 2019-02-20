#!/usr/bin/env bash
NGINX='nginx'
PHP='php'

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
        sudo rm -rf $i
    done
}

function install_nginx() {
    sudo apt-get update
    sudo apt-get -y install nginx
    NIGINX_PATH=/etc/nginx
    echo 输入自定义nginx配置文件
    read CONFIG_FILE
    sudo touch ${NIGINX_PATH}/sites-available/${CONFIG_FILE}
    sudo ln -s ${NIGINX_PATH}/sites-available/${CONFIG_FILE} ${NIGINX_PATH}/sites-enabled/${CONFIG_FILE}
}

LOG "安装${NGINX}"
if [ -n `command -v ${NGINX}` ]; then
    nginx_version=`nginx -v`
    echo ${NGINX}当前版本${nginx_version}
    echo "是否卸载${NGINX}(y or n)"
    read flag
    if [ "$flag" = "y" ]; then
        echo 开始卸载Nginx
        sudo apt-get --purge remove nginx; sudo apt-get autoremove; sudo apt-get --purge remove nginx; sudo apt-get --purge remove nginx-common; sudo apt-get --purge remove nginx-core
        delete_file ${NGINX}
        kill_pid ${NGINX}

        echo 开始重装Nginx
        install_nginx
        echo 启动${NGINX}
        sudo service nginx start
        echo 启动${NGINX}成功
        nginx_version=`nginx -v`
    fi
fi

LOG "安装${PHP}"
function install_php() {
    sudo rm /var/cache/apt/archives/lock
    sudo rm /var/lib/dpkg/lock
    sudo apt-get udpate
    sudo apt-get install php php-fpm php-mysql php-xml php-gd php-curl -y
    php_version=`php -v`
    echo ${PHP}当前版本${php_version}
}

if [ -n `command -v ${PHP}` ]; then
    php_version=`php -v`
    echo ${PHP}当前版本${nginx_version}
    echo "是否卸载${PHP}(y or n)"
    read flag
    if [ "$flag" = "y" ]; then
        echo 开始卸载${PHP}
        uninstall=`sudo apt-get autoremove php7*`
        delete_file ${PHP}7
        kill_pid ${PHP}

        install_php
        echo "启动PHP请输入php版本（php7.0-fpm）"
        read php_version
        sudo service ${php_version} start
        echo 启动${PHP}成功
    else
        exit
    fi
fi