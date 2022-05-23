#!/bin/bash

fhome=/usr/share/abot2/
fcache=$fhome"cache/1/"
#chmod +rx -R $fhome

tm=0
k=0;
fPID=$fhome"abot1_pid.txt"

PID=$$
echo $PID > $fPID

[ -f $fhome"tm.txt" ] && tm=$(sed -n 1"p" $fhome"tm.txt" | tr -d '\r')

zap=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $fhome"settings.conf" | tr -d '\r')
portapi=$(sed -n 17"p" $fhome"settings.conf" | tr -d '\r')


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" abot1_"$bui": "$1
else
	echo $date1" abot1_"$bui": "$1 >> $log
fi
}


while true 
do
k=$((k+1))
tm=$((tm+1))
echo $tm > $fhome"tm.txt"
nc -l -p $portapi > $fcache$tm".xt"
#chmod +rx -R $fcache
logger "---->"$tm".xt"
sleep 1

done



rm -f $fPID
