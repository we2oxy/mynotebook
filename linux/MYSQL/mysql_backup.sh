#!/bin/bash

function mysql_backup(){
	#tbinfo文件只包含表结构，dbdata文件只包含表数据。
	#--master-data=2 将change master 语句写入dump文件中
	mysqldump -hlocalhost -uroot -p'PASS' --single-transaction --no-data --master-data=2 --databases DB_NAME >/opt/DB_NAME_tbinfo_backup_`date +%F_%H%M%S`.sql
	mysqldump -hlocalhost -uroot -p'PASS' --single-transaction --no-data --databases DB_NAME >/opt/DB_NAME_tbinfo_backup_`date +%F_%H%M%S`.sql
	mysqldump -hlocalhost -uroot -p'PASS' --single-transaction --no-create-info --databases DB_NAME >/opt/DB_NAME_dbdata_backup_`date +%F_%H%M%S`.sql
	mysqldump -hlocalhost -uroot -p'PASS' --single-transaction --apply-slave-statements --master-data=2 -default-character-set=utf8mb4 --events --routines --triggers --databases DB_NAME >/opt/DB_NAME_dbdata_backup_`date +%F_%H%M%S`.sql
}


function auto_del_backupfile(){
	#压缩3天前备份的sql文件
	find /opt/ -type f -name "DB_NAME*backup*.sql" -mtime +3 | xargs -I {} gzip -9 {}
	#删除两个月前备份的sql文件
	find /opt/ -type f -name "DB_NAME*backup*.sql.gz" -mtime +61 | xargs -I {} rm -f {}
}


mysql_backup
auto_del_backupfile