#!/bin/bash
HOSTNAME=$(/usr/bin/hostname)
#echo $HOSTNAME
IP=$( /usr/sbin/ifconfig eth0 | grep "inet" | awk '{ print $2}')
NUM=$(ps -ef | wc -l)
#echo $NUM
if [ $NUM -gt 10000 ];then
   /usr/bin/curl 'https://oapi.dingtalk.com/robot/send?access_token=a47b10dd72bc720d688a9e2f972f8f90f93eaac978afa50dfae13ecd9395b8c7' -H 'Content-Type: application/json' -d '{"msgtype": "text", "text": { "content": "'"$(date)"'-主机名：'"$HOSTNAME"'-IP地址：'"$IP"'-当前机器进程机器总数：'"$NUM"'" },  "at": { "atMobiles": [ "18516683226",  "15234024678" ],  "isAtAll": false }}'
else
  echo 进程数小于10000个;
fi
#curl 'https://oapi.dingtalk.com/robot/send?access_token=xxxxxxx' -H 'Content-Type: application/json' -d '{"msgtype": "text", "text": { "content": "主机名：'"$HOSTNAME"'----当前机器进程机器总数：'"$NUM"'" },  "at": { "atMobiles": [ "18516683226",  "15234024678" ],  "isAtAll": false }}'
