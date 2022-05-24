#!/bin/bash

ftb=/usr/share/abot2/
fPID=$ftb"cu2_pid.txt"

Z1="0"
Z2="0"
code1=""
code2=""


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" cucu2_"$bui": "$1
fi
}


directly () {

IFS=$'\x10'
text=`cat $f_text`
echo "token="$token
echo "chat_id="$chat_id
echo $text

if [ -z "$proxy" ]; then
[ "$Z1" == "0" ] && [ "$Z2" == "0" ] && curl -k -s -m 13 -L -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text > $ftb"out0.txt"
[ "$Z1" != "0" ] || [ "$Z2" != "0" ] && curl -k -s -m 13 -L -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1</b>"$text > $ftb"out0.txt"

else
[ "$Z1" == "0" ] && [ "$Z2" == "0" ] && curl -k -s -m 13 --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text > $ftb"out0.txt"
[ "$Z1" != "0" ] || [ "$Z2" != "0" ] && curl -k -s -m 13 --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text=<b>$code1</b>"$text > $ftb"out0.txt"

fi

mv $ftb"out0.txt" $ftb"out.txt"

}


if ! [ -f $fPID ]; then		#----------------------- старт------------------
PID=$$
echo $PID > $fPID
logger "start"
token=$(sed -n "1p" $ftb"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $ftb"settings.conf" | tr -d '\r')
f_text=$(sed -n "2p" $ftb"send.txt" | tr -d '\r')
proxy=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $ftb"settings.conf" | tr -d '\r')
sty=$(sed -n 20"p" $ftb"settings.conf" | tr -d '\r')

[ "$bicons" == "1" ] && Z1=$1
[ "$sty" == "1" ] && Z2=$2

logger "Z1="$Z1
logger "Z2="$Z2

[ "$Z1" == "1" ] && code1="&#10060;"
[ "$Z1" == "2" ] && code1="&#9989"

str_col=$(grep -cv "^#" $ftb"chats.txt")
logger "str_col="$str_col
if [ "$str_col" -gt "0" ]; then
for (( i=1;i<=$str_col;i++)); do
	chat_id=$(sed -n $i"p" $ftb"chats.txt" | sed 's/z/-/g' | tr -d '\r')
	logger "chat_id="$chat_id
	directly;
done
fi





fi #----------------------- конец старт------------------
rm -f $fPID
