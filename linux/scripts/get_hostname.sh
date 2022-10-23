#!/bin/bash

exporter_port=9100

echo "# export `date +%F_%T`">/tmp/hostname.txt

for i in `cat hosts.txt`
do
echo $i `curl -s http://${i}:${exporter_port}/metrics | awk 'BEGIN{FS=","} /nodename=/ {print $3}' |sed -e 's#nodename=##' -e 's#"##g'` >> /tmp/hostname.txt
done 
cat /tmp/hostname.txt
