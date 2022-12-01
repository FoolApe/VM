#!/bin/bash

#list="/home/sys-admin/juro_lin/script/VM/down_list"
table="/home/sys-admin/juro_lin/script/VM/NMS.json"
list="/tmp/test_list"

### Get all list
curl -sd '{"token":"6faa921d633262de5455fb7504bd65ed","type":"list"}' http://nms-api.vir999.com/api/a_table/ |jq . > $table

### Main script
for a in $(cat $list)
do
{
	sn=`cat $table |grep -wB5 "$a" |grep sn |awk -F \: '{print $2}' |sed 's/\"//g' |sed 's/\,//g' |sed 's/\ //g'`
	echo "$a,$sn"
	curl -sd '{"token":"6faa921d633262de5455fb7504bd65ed","type":"edit","sn":"'$sn'","status":"線上","uid":"hcl_system","monitor":"0"}' http://nms-api.vir999.com/api/a_table/
	curl -sd '{"token":"6faa921d633262de5455fb7504bd65ed","type":"del","sn":"'$sn'","uid":"'hcl_system'","pms_id":"'hcl_system'"}' http://nms-api.vir999.com/api/a_table/
}&

NPROC=$(($NPROC+1))
if [ "$NPROC" -ge 10 ]; then
	wait
	NPROC=0
fi
done
