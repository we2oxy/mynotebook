#!/bin/bash


fe_port_num=`ss -antpl|egrep '8030|9010|9020|9030'|wc -l`	
be_port_num=`ss -antpl|egrep '9060|9050|8040|8060'|wc -l`
time_stamp=`date +%F_%T`
log_file=/tmp/monitor.log
sr_path=/app/starrocks-2.3.0

fe_is_down=`cat /tmp/fe_status.txt|wc -l`
be_is_down=`cat /tmp/be_status.txt|wc -l`


function check_fe_status(){
	if [[ ${fe_port_num} -eq 4 ]];then
		fe_status=0
	else
		echo "${time_stamp} fe is down!" >> /tmp/fe_status.txt
		fe_status=1
}

function check_be_status(){
	if [[ ${be_port_num} -eq 4 ]];then
		be_status=0
	else
		echo "${time_stamp} be is down!" >> /tmp/be_status.txt
		be_status=1
}

function reload_fe(){
	sh ${sr_path}/fe/bin/stop_fe.sh
	sleep 3
	sh ${sr_path}/fe/bin/start_fe.sh
	echo "${time_stamp} reload fe" >> ${log_file}
}

function reload_be(){
	sh ${sr_path}/be/bin/stop_be.sh
	sleep 3
	sh ${sr_path}/be/bin/start_be.sh
	echo "${time_stamp} reload be" >> ${log_file}
}

function oncall(){
	#curl -s http://www.baidu.com
	echo oncall >> ${log_file}
}

function main_fe(){
	if [[ ${fe_status} -eq 1 ]];then
		if [[ ${fe_is_down} -lt 4 ]];then
			# fe状态异常且宕机次数小于4次，自动重启fe。
			reload_fe
		else
			# fe状态异常且宕机3次，进行电话通知。
			oncall
	else
		echo "${time_stamp} fe is normal" >> ${log_file}
}


function main_be(){
	if [[ ${be_status} -eq 1 ]];then
		if [[ ${be_is_down} -lt 4 ]];then
			# be状态异常且宕机次数小于4次，自动重启fe。
			reload_be
		else
			# be状态异常且宕机3次，进行电话通知。
			oncall
	else
		echo "${time_stamp} be is normal" >> ${log_file}
}


check_fe_status
check_be_status
main_fe
main_be