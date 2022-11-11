#!/bin/bash
:<<!
author:vla
Sun Jan  9 08:01:11 CST 2022
This Scripts For install mysql ！
Usage:bash mysql_install.sh mysql-5.7.23-el7-x86_64.tar.gz
!


set -x 


INSTALL_VERSION=$(basename $1|cut -b -12)
UNTAR=$(echo ${1%.tar.gz})
MYSQL_USER=mysql
MYSQL_GRP=mysql
MYSQL_PREFIX=/usr/local/mysql
MYSQL_DATADIR=/mysql_data
MYSQL_CONF=/etc/my.cnf
MYSQL_ENV=/etc/profile.d/env_mysql.sh


function check_user(){
    [ ! $UID -eq 0 ] && echo 'pls use root execute this scripts' && exit 1
}

function check_os_version(){
	egrep "CentOS Linux 7" /etc/os-release >/dev/null 2>&1
	[ ! $? -eq 0 ] && echo 'This Scripts For CentOS7 Use' && exit 2

}

function check_args(){
    [ ! $# -eq 1 ]  && echo "Usage:bash mysql_install.sh mysql-5.7.23-el7-x86_64.tar.gz" && exit 3
}

function init_mysql_basedir(){
    tar -zxf $1 -C /usr/local/
    mv /usr/local/${UNTAR} /usr/local/${INSTALL_VERSION}
    ln -s /usr/local/${INSTALL_VERSION} ${MYSQL_PREFIX}
}

function init_mysql_conf(){
	[ -f ${MYSQL_CONF} ] && rm -f ${MYSQL_CONF}
cat >> /etc/my.cnf <<EOF
[client]
port=3306
socket=/mysql_data/mysql.sock
default-character-set=UTF8MB4
[mysql]
no-auto-rehash
[mysqld]
bind_address=0.0.0.0
user=mysql
port=3306
server_id=1
skip_name_resolve=1
explicit_defaults_for_timestamp=1
basedir=/usr/local/mysql
datadir=/mysql_data
socket=/mysql_data/mysql.sock
character_set_server=UTF8MB4
EOF
}

function init_mysql_datadir(){
	[ -d ${MYSQL_DATADIR} ] && echo "${MYSQL_DATADIR} already exits!" && exit 3
	mkdir ${MYSQL_DATADIR}
}

function init_mysql_user(){
	egrep "${MYSQL_GRP}" /etc/group >/dev/null 2>&1
	[ ! $? -eq 0 ] && CHK_MYSQLGRP=0
	id ${MYSQL_USER}  >/dev/null 2>&1
	[ ! $? -eq 0 ] && CHK_MYSQLUSER=0
	[ ${CHK_MYSQLGRP} -eq 0 -a ${CHK_MYSQLUSER} -eq 0 ] && sh -c "groupadd ${MYSQL_GRP} && useradd -r -g ${MYSQL_GRP} -s /bin/false ${MYSQL_USER}" || sh -c "echo 'USER:${MYSQL_USER} or GROUP:${MYSQL_GRP} already exits';exit"
}

function chowner_mysql(){
	chown -R ${MYSQL_USER}:${MYSQL_GRP} /usr/local/${INSTALL_VERSION} ${MYSQL_PREFIX} ${MYSQL_DATADIR} ${MYSQL_CONF}
	chmod -R 750 ${MYSQL_DATADIR}
}

function init_mysql_env(){
	[ ! -f ${MYSQL_ENV} ] && echo 'export PATH=$PATH:/usr/local/mysql/bin' > ${MYSQL_ENV} || echo 'export PATH=$PATH:/usr/local/mysql/bin' > /etc/profile.d/environment_mysql.sh
}

function init_mysql_db(){
	[ ! -d ${MYSQL_DATADIR}/mysql ] && ${MYSQL_PREFIX}/bin/mysqld --initialize-insecure --user=${MYSQL_USER} --basedir=${MYSQL_PREFIX} --datadir=${MYSQL_DATADIR}
}

function start_mysql_srv(){
	source /etc/profile >/dev/null 2>&1 
	cp ${MYSQL_PREFIX}/support-files/mysql.server /etc/init.d/mysql.server
	sh -c "/etc/init.d/mysql.server start"
	ps -ef | grep mysqld >/dev/null 2>&1 && echo -e 'mysql install successful! \npls use temp password login and reset passsword!'
}

function reset_mysql_pass(){
	mysqladmin password 123123
	#mysqladmin -uroot -p123123 flush-privileges
	mysql -uroot -p123123 -e "create user 'root'@'%' IDENTIFIED BY '123123';"
	mysql -uroot -p123123 -e "flush privileges;"
}

check_user
check_os_version
check_args $1
init_mysql_basedir $1
init_mysql_conf
init_mysql_datadir
init_mysql_user
chowner_mysql
init_mysql_env
init_mysql_db
start_mysql_srv
