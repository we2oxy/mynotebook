#!/bin/bash
:<<!
author:vla
Fri Nov 11 23:33:16 CST 2022
This Scripts For install mysql
Usage:bash mysql_install.sh mysql-5.7.25-linux-glibc2.12-x86_64.tar.gz
!

set -x 

INSTALL_VERSION=$(basename $1|cut -b -12)
UNTAR=$(echo ${1%.tar.gz})
MYSQL_USER=mysql
MYSQL_GRP=mysql
MYSQL_PREFIX=/usr/local/mysql
MYSQL_DATADIR=/usr/local/mysql/db_data
MYSQL_CONF=/etc/my.cnf
MYSQL_ENV=/usr/local/mysql/env_mysql.sh


function check_list(){
	#check user
	[ ! $UID -eq 0 ] && echo 'pls use root execute this scripts' && exit 1
	#check os_version
	egrep "CentOS Linux 7" /etc/os-release >/dev/null 2>&1
	[ ! $? -eq 0 ] && echo 'This Scripts For CentOS7 Use' && exit 2
	# check_args
	[ ! $# -eq 1 ]	&& echo "Usage:bash mysql_install.sh mysql-5.7.23-el7-x86_64.tar.gz" && exit 3
}

function init_mysql_user(){
	groupadd ${MYSQL_GRP} &>/dev/null || sh -c "echo '${MYSQL_GRP} group is exits' && exit 4"
	id ${MYSQL_USER} &>/dev/null || sh -c "echo 'USER:${MYSQL_USER} or GROUP:${MYSQL_GRP} already exits';exit 5"
	useradd -r -g ${MYSQL_GRP} -s /bin/false ${MYSQL_USER} 
}

function init_mysql(){
	# init basedir
	tar -zxf $1 -C /usr/local/
	mv /usr/local/${UNTAR} /usr/local/${INSTALL_VERSION}
	ln -s /usr/local/${INSTALL_VERSION} ${MYSQL_PREFIX}
	# init mysql_conf
	[ -f ${MYSQL_CONF} ] && mv ${MYSQL_CONF} ${MYSQL_CONF}-`date +%F_%T`
	[ -f /root/.my.cnf ] && mv /root/.my.cnf /root/.my.cnf-`date +%F_%T`
	echo -e "[client]\nport=3306\ndefault-character-set=UTF8MB4\nno-auto-rehash" > /root/.my.cnf
	echo -e "[mysqld]\nserver-id=`date +%s`\nport=3306\nbind_address=0.0.0.0\nuser=mysql\ncharacter_set_server=UTF8MB4\nbasedir=${MYSQL_PREFIX}\ndatadir=${MYSQL_DATADIR}\nsocket=${MYSQL_PREFIX}/mysql.sock\nlog-error=${MYSQL_PREFIX}/error.log\nlog_bin=${MYSQL_PREFIX}/binlog" > ${MYSQL_CONF}
	# init mysql_datadir
	[ -d ${MYSQL_DATADIR} ] && echo "${MYSQL_DATADIR} already exits!" && exit 6
	mkdir -p ${MYSQL_DATADIR} ${MYSQL_PREFIX}/binlog
	echo "" > ${MYSQL_PREFIX}/error.log
	# chowner mysql
	chown -R ${MYSQL_USER}:${MYSQL_GRP} /usr/local/${INSTALL_VERSION} ${MYSQL_PREFIX}  
	chmod -R 750 ${MYSQL_DATADIR}
	# mysql env_mysql
	echo 'export PATH=$PATH:/usr/local/mysql/bin' > ${MYSQL_PREFIX}/env.sh
	# init mysql_db
	[ ! -d ${MYSQL_DATADIR}/mysql ] && ${MYSQL_PREFIX}/bin/mysqld --initialize --user=${MYSQL_USER}
	grep "A temporary password" ${MYSQL_PREFIX}/error.log > ${MYSQL_PREFIX}/passwd.txt
	# init start scripts
	cp ${MYSQL_PREFIX}/support-files/mysql.server /etc/init.d/mysql.server
	echo "MySQL install successful!"
}


function reset_mysql_pass(){
	#mysqladmin password 123123
	#mysqladmin -uroot -p123123 flush-privileges
	echo -e "ALTER USER 'root'@'localhost' identified by '123123';\ncreate user 'root'@'%' IDENTIFIED BY '123123';\nGRANT ALL ON *.* TO 'root'@'%';\nflush privileges;" > ${MYSQL_PREFIX}/reset.sql

}

check_list $1
init_mysql_user
init_mysql $1
reset_mysql_pass
