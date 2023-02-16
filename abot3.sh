#!/bin/bash

#переменные
fhome=/usr/share/abot2/
fcache1=$fhome"cache/1/"
fcache2=$fhome"cache/2/"
fPIDcu2=$fhome"cu2_pid.txt"
f_send=$fhome"send_abot3.txt"
log="/var/log/trbot/trbot.log"
lev_log=$(sed -n 14"p" $ftb"settings.conf" | tr -d '\r')
ftb=$fhome
cuf=$fhome
fPID=$fhome"abot3_pid.txt"



function Init() 
{
[ "$lev_log" == "1" ] && logger "Init"
chat_id1=$(sed -n 1"p" $fhome"chats.txt" | sed 's/z/-/g' | tr -d '\r')

regim=$(sed -n 3"p" $fhome"settings.conf" | tr -d '\r')
proxy=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
sec=$(sed -n 6"p" $fhome"settings.conf" | tr -d '\r')
em=$(sed -n 8"p" $fhome"settings.conf" | tr -d '\r')
zap=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')
ssec=$(sed -n 12"p" $fhome"settings.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"settings.conf" | tr -d '\r')
lev_log=$(sed -n 14"p" $fhome"settings.conf" | tr -d '\r')
tst=$(sed -n 16"p" $fhome"settings.conf" | tr -d '\r')
portapi=$(sed -n 17"p" $fhome"settings.conf" | tr -d '\r')
ipapi=$(sed -n 18"p" $fhome"settings.conf" | tr -d '\r')
bicons=$(sed -n 19"p" $ftb"settings.conf" | tr -d '\r')
sty=$(sed -n 20"p" $ftb"settings.conf" | tr -d '\r')

promapi=$(sed -n 21"p" $ftb"settings.conf" | tr -d '\r')
label1=$(sed -n 22"p" $ftb"settings.conf" | tr -d '\r')
groupp=$(sed -n 23"p" $ftb"settings.conf" | tr -d '\r')

sm=$(sed -n 24"p" $ftb"settings.conf" | tr -d '\r')
mdt_start=$(sed -n 26"p" $ftb"settings.conf" | sed 's/\://g' | tr -d '\r')
mdt_end=$(sed -n 27"p" $ftb"settings.conf" | sed 's/\://g' | tr -d '\r')

kkik=0
bic="0"
styc="0"
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" abot3_"$bui": "$1
else
	echo $date1" abot3_"$bui": "$1 >> $log
fi
}



function alert_bot()
{

[ "$lev_log" == "1" ] && logger "prom api checks"

autohcheck;
if [ "$autohcheck_rez" -eq "0" ]; then
	if [ -z "$proxy" ]; then
		curl -k -s -m 13 "$promapi" | jq '.' > $fhome"a3.txt"
	else
		curl -k -s -m 13 --proxy $proxy "$promapi" | jq '.' > $fhome"a3.txt"
	fi
[ "$lev_log" == "1" ] && cat $fhome"a3.txt"
if [ $(grep -c '\"status\"\: \"success\"' $fhome"a3.txt" ) -eq "1" ]; then
logger "status success"
str_col=$(grep -cv "^---" $fhome"a3.txt")
logger "bot api str_col="$str_col
if [ "$str_col" -gt "6" ]; then
num_alerts=$(grep -c 'alertname' $fhome"a3.txt" )
echo "" > $fhome"newalerts.txt"
redka;

fi
comm_vessels;
fi
fi


[ "$lev_log" == "1" ] && logger "prom api checks ok"

}

function gen_id_alert() 
{

oldid=$(sed -n 1"p" $fhome"id.txt" | tr -d '\r')
newid=$((oldid+1))
echo $newid > $fhome"id.txt"

}

function redka()
{
[ "$lev_log" == "1" ] && logger "start redka"
logger "redka num_alerts="$num_alerts

for (( i1=0;i1<$num_alerts;i1++)); do
rm -f $f_send

bic="0"
styc="0"
code2=""

alertname=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.alertname' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
groupp1=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.'${label1}'' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
inst=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.instance' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
jober=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.job' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
severity=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].labels.severity' | sed 's/"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
desc=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].annotations.description' | sed 's/"/ /g' | sed 's/UTC/ /g' | sed 's/+0000/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//'`
unic=`cat $fhome"a3.txt" | jq '.data.alerts['${i1}'].annotations.unicum'`


[ "$lev_log" == "1" ] && logger "redka i1="$i1
[ "$lev_log" == "1" ] && logger "redka alertname="$alertname
[ "$lev_log" == "1" ] && logger "redka groupp1="$groupp1
[ "$lev_log" == "1" ] && logger "redka severity="$severity
[ "$lev_log" == "1" ] && logger "redka inst="$inst
[ "$lev_log" == "1" ] && logger "redka jober="$jober
[ "$lev_log" == "1" ] && logger "redka desc="$desc
[ "$lev_log" == "1" ] && logger "redka unic="$unic

if [ "$severity" != "keepalive" -a "$groupp" == "$groupp1" ]; then

finger=$(echo -n $alertname$inst$jober$severity$unic | md5sum | awk '{print $1}')
echo $finger >> $fhome"newalerts.txt"

[ "$severity" == "info" ] && styc="1" && code2="<b>&#9898;</b>"
[ "$severity" == "warning" ] && styc="2" && code2="<b>&#x1F7E1;</b>"
[ "$severity" == "average" ] && styc="3" && code2="<b>&#x1F7E0;</b>"
[ "$severity" == "high" ] && styc="4" && code2="<b>&#128308;</b>"
[ "$severity" == "disaster" ] && styc="5" && code2="<b>&#128996;</b>"

severity1=""
severity2=", severity: "$severity
[ "$sty" == "2" ] && severity1=$severity2


desc3=""
if ! [ -z "$tst" ]; then
desc1=$(echo $desc | awk -F", ${tst}:" '{print $1}')
desc2=$(echo $desc | awk -F", ${tst}:" '{print $2}'| awk -F"." '{print $1}')
desc=$desc1
desc3=", "$tst":"$desc2 #Started at 
desc4=", Started at "$desc2
[ "$lev_log" == "1" ] && logger "redka new desc="$desc
fi

logger "redka finger="$finger
if ! [ "$(grep $finger $fhome"alerts.txt")" ]; then
	logger "- new alert"
	if ! [ "$(grep $finger $fhome"delete.txt")" ]; then
		[ "$lev_log" == "1" ] && logger "-1"
		gen_id_alert;
		[ "$bicons" == "1" ] && bic="1"
		echo $newid" "$finger >> $fhome"alerts.txt"
		logger "redka newid="$newid
		
		[ "$sty" == "0" ] && echo $newid" "$desc$desc4 >> $fhome"alerts2.txt"
		[ "$sty" == "1" ] && echo $code2$newid" "$desc$desc4 >> $fhome"alerts2.txt"
		[ "$sty" == "2" ] && echo $newid" "$desc$severity1$desc4 >> $fhome"alerts2.txt"
		
		[ "$bicons" == "0" ] && [ "$sty" == "0" ] && echo "[ALERT] "$newid" "$desc$desc3 >> $f_send
		[ "$bicons" == "0" ] && [ "$sty" == "1" ] && echo "[ALERT] "$newid" "$desc$desc3 >> $f_send
		[ "$bicons" == "0" ] && [ "$sty" == "2" ] && echo "[ALERT] "$newid" "$desc$severity1$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "0" ] && echo $newid" "$desc$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "1" ] && echo $code2$newid" "$desc$desc3 >> $f_send
		[ "$bicons" == "1" ] && [ "$sty" == "2" ] && echo $newid" "$desc$severity1$desc3 >> $f_send
		
		[ "$em" == "1" ] && echo "[ALERT] Problem "$newid$severity2 > $fhome"mail.txt" && echo "[ALERT] "$newid" "$desc$desc3 >> $fhome"mail.txt" && $ftb"sendmail.sh"
		
		#silent_mode
		silent_mode;
		if [ "$silent_mode" == "on" ]; then
		[ "$severity" == "high" ] && to_send;
		[ "$severity" == "disaster" ] && to_send;
		else
		to_send;
		fi
		
	else
	logger "finger "$finger" already removed earlier"
	fi
else
logger "finger "$finger" is already in alerts"
fi
fi

done

#to_send;

}

resolv_sever2()
{
smt1=""; smt2=""; smt3=""; smt4=""
smt1=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#128996;" )
! [ -z "$smt1" ] && severity2=", severity: disaster"
smt2=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#128308;" )
! [ -z "$smt2" ] && severity2=", severity: high"
smt3=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: high" )
! [ -z "$smt3" ] && severity2=", severity: high"
smt4=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: disaster" )
! [ -z "$smt4" ] && severity2=", severity: disaster"

smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#9898;" )
! [ -z "$smt0" ] && severity2=", severity: info"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#x1F7E1;" )
! [ -z "$smt0" ] && severity2=", severity: warning"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#x1F7E0;" )
! [ -z "$smt0" ] && severity2=", severity: average"
smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: high" )

smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: info" )
! [ -z "$smt0" ] && severity2=", severity: info"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: warning" )
! [ -z "$smt0" ] && severity2=", severity: warning"
smt0=""; smt0=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: average" )
! [ -z "$smt0" ] && severity2=", severity: average"
}

comm_vessels()
{
[ "$lev_log" == "1" ] && logger "comm_vessels checks"
cp -f $fhome"alerts.txt" $fhome"alerts_old.txt"
str_col=$(grep -cv "^---" $fhome"alerts_old.txt")
logger "comm_vessels alerts_old str_col="$str_col
for (( i=1;i<=$str_col;i++)); do
	rm -f $f_send
	test=$(sed -n $i"p" $fhome"alerts_old.txt" | awk '{print $2}' | tr -d '\r')
	num=$(grep -n "$test" $fhome"newalerts.txt" | awk -F":" '{print $1}')
	if [ -z "$num" ]; then
		[ "$lev_log" == "1" ] && logger "comm_vessels check "$test" in newalerts.txt not found"
		
		testid=$(sed -n $i"p" $fhome"alerts_old.txt" | awk '{print $1}' | tr -d '\r')
		num1=$(grep -n "$test" $fhome"alerts.txt" | awk -F":" '{print $1}')
		num2=$(grep -n "$testid" $fhome"alerts2.txt" | awk -F":" '{print $1}')
		
		#---resolved
		[ "$bicons" == "1" ] && bic="2"
		
		desc4=$(sed -n $num2"p" $fhome"alerts2.txt" | tr -d '\r')
		local date2=`date '+ %Y-%m-%d %H:%M:%S'`
		desc3=", timestamp: "$date2
		[ "$bicons" == "0" ] && echo "[OK] "$desc4$desc3 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk '{print $2}')
		[ "$bicons" != "0" ] && echo $desc4$desc3 >> $f_send && idprob=$(sed -n "1p" $f_send | tr -d '\r' | awk -F"</b>" '{print $2}' | awk '{print $1}')
		logger "resolved idprob="$idprob" finger="$test
		
		resolv_sever2;
		desc4=$(sed -n $num2"p" $fhome"alerts2.txt" | tr -d '\r' | awk -F"</b>" '{print $2}')
		[ "$em" == "1" ] && echo "[OK] Resolved "$idprob$severity2 > $fhome"mail.txt" && echo "[OK] "$desc4$desc3 >> $fhome"mail.txt" && $ftb"sendmail.sh"
		
		
		#silent_mode
		silent_mode;
		if [ "$silent_mode" == "on" ]; then
		#smt1=""; smt2=""; smt3=""; smt4=""
		#smt1=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#128996;" )
		#smt2=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "&#128308;" )
		#smt3=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: high" )
		#smt4=$(sed -n $num2'p' $fhome"alerts2.txt" | grep "severity: disaster" )
		logger "resolved smt1="$smt1", smt2="$smt2", smt3="$smt3", smt4="$smt4
		! [ -z "$smt1" ] || ! [ -z "$smt2" ] || ! [ -z "$smt3" ] || ! [ -z "$smt4" ] && to_send;
		else
			to_send;
		fi
		
		#resolved---
		
		str_col1=$(grep -cv "^---" $fhome"alerts.txt")
		str_col2=$(grep -cv "^---" $fhome"alerts2.txt")
		
		head -n $((num1-1)) $fhome"alerts.txt" > $fhome"alerts1_tmp.txt"
		tail -n $((str_col1-num1)) $fhome"alerts.txt" >> $fhome"alerts1_tmp.txt"
		cp -f $fhome"alerts1_tmp.txt" $fhome"alerts.txt"
		
		head -n $((num2-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num2)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
	else
		[ "$lev_log" == "1" ] && logger "comm_vessels check "$test" in newalerts.txt detected"
	fi

done

echo "" > $fhome"newalerts.txt"
}


silent_mode ()
{
silent_mode="off"
[ "$lev_log" == "1" ] && logger "--------------silent_mode------------------"
if [ "$sm" == "1" ]; then
		mdt1=$(date '+%H:%M:%S' | sed 's/\://g' | tr -d '\r')
		[ "$lev_log" == "1" ] && logger "silent_mode mdt1="$mdt1
		[ "$lev_log" == "1" ] && logger "silent_mode mdt_start="$mdt_start
		[ "$lev_log" == "1" ] && logger "silent_mode mdt_end="$mdt_end
		if [ "$mdt1" \> "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]; then
			silent_mode="on"
		fi
fi
logger "silent_mode="$silent_mode

}



function to_send() 
{
[ "$lev_log" == "1" ] && logger "start to_send"

regim=$(sed -n "1p" $fhome"amode.txt" | tr -d '\r')

if [ -f $f_send ]; then
	if [ "$regim" == "1" ]; then
		logger "Regim ON"
		if ! [ -z "$chat_id1" ]; then
			otv=$f_send
			send
			rm -f $f_send
			else
			logger "No chat_id1"
		fi
	fi
fi

}


send1 () 
{

[ "$lev_log" == "1" ] && logger "send1 start"

echo $chat_id > $cuf"send3.txt"
echo $otv >> $cuf"send3.txt"

rm -f $cuf"out.txt"
file=$cuf"out.txt"; 
$ftb"cucu3.sh" $bic $styc &
pauseloop;

if [ -f $cuf"out.txt" ]; then
	if [ "$(cat $cuf"out.txt" | grep ":true,")" ]; then	
		logger "send OK"
	else
		logger "send file+, timeout.."
		cat $cuf"out.txt" >> $log
		sleep 2
	fi
else	
	logger "send FAIL"
	if [ -f $cuf"cu2_pid.txt" ]; then
		logger "send kill cucu3"
		cu_pid=$(sed -n 1"p" $cuf"cu2_pid.txt" | tr -d '\r')
		killall cucu3.sh
		kill -9 $cu_pid
		rm -f $cuf"cu2_pid.txt"
	fi
fi

[ "$lev_log" == "1" ] && logger "send1 exit"

}



send ()
{
[ "$lev_log" == "1" ] && logger "send start"
rm -f $cuf"send3.txt"

chat_id=$(sed -n 2"p" $ftb"settings.conf" | sed 's/z/-/g' | tr -d '\r')
[ "$lev_log" == "1" ] && logger "chat_id="$chat_id

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	echo "sv="$sv
	$ftb"rex.sh" $otv
	
	for (( i=1;i<=$sv;i++)); do
		otv=$fhome"rez"$i".txt"
		send1;
		rm -f $fhome"rez"$i".txt"
	done
	
else
	send1;
fi
}


pauseloop ()  		
{
sec1=0
rm -f $file
again0="yes"
while [ "$again0" = "yes" ]
do
sec1=$((sec1+1))
sleep 1
if [ -f $file ] || [ "$sec1" -eq "$sec" ]; then
	again0="go"
	[ "$lev_log" == "1" ] && logger "pauseloop sec1="$sec1
fi
done
}



autohcheck ()
{
autohcheck_rez=$(curl -I -k -m 13 "$promapi" 2>&1 | grep -cE 'Failed')

if [ "$autohcheck_rez" -eq "1" ]; then
	logger "autohcheck prom api Failed"
else
	logger "autohcheck prom api OK"
fi

}


PID=$$
echo $PID > $fPID
logger "start"
Init;

while true
do
sleep $ssec
alert_bot;
#to_send;
kkik=$(($kkik+1))
if [ "$kkik" -ge "$progons" ]; then
	autohcheck 
	Init
fi
done



rm -f $fPID

