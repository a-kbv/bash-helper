#!/bin/bash

#This script will display the number of connections per IP address on port 80

clear;
while x=0; 
do clear;
date;
echo "";
echo "  [Count] | [IP ADDR]";
echo "-------------------";
netstat -np|grep :80|grep -v LISTEN|awk '{print $5}'|cut -d: -f1|uniq -c; sleep 5;
done