#!/bin/bash

home_trbot=/usr/share/abot2/
fhome=$home_trbot
log="/var/log/trbot/trbot.log"
zap=$(sed -n 10"p" $fhome"settings.conf" | tr -d '\r')
bui=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')


iter=$2" "$3" "$4" "$5" "$6" "$7" "$8
echo $iter | tr " " "\n" > $home_trbot"temp_del.txt"

#state="ok"



function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`

if [ "$zap" == "1" ]; then
	echo $date1" del_"$bui": "$1
else
	echo $date1" del_"$bui": "$1 >> $log
fi
}


function deleteler() 
{
[ "$test" == "all" ] && cat $fhome"alerts.txt" >> $fhome"delete.txt" && rm -f $home_trbot"alerts2.txt" && rm -f $home_trbot"alerts.txt" && touch $home_trbot"alerts2.txt" && touch $home_trbot"alerts.txt" && echo $test" check" && echo "delete all ok" > $home_trbot"del.txt" && exit 0

str_col2=$(grep -cv "^#" $home_trbot"alerts2.txt")
logger "str_col2="$str_col2

num=$(grep -n "$test" $fhome"alerts2.txt" | awk -F":" '{print $1}')
logger "num="$num

if [ -z "$num" ]; then	
	state=$state" (NOT ok)"
	logger $test" not find"
else					
		state=$state" (ok)"
		
		fp=$(sed -n $num"p" $fhome"alerts.txt" | tr -d '\r')
		#echo $fp >> $fhome"delete.txt"		
		echo $fp >> $fhome"delete.txt"
		
		head -n $((num-1)) $fhome"alerts2.txt" > $fhome"alerts2_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts2.txt" >> $fhome"alerts2_tmp.txt"
		cp -f $fhome"alerts2_tmp.txt" $fhome"alerts2.txt"
		
		head -n $((num-1)) $fhome"alerts.txt" > $fhome"alerts1_tmp.txt"
		tail -n $((str_col2-num)) $fhome"alerts.txt" >> $fhome"alerts1_tmp.txt"
		cp -f $fhome"alerts1_tmp.txt" $fhome"alerts.txt"
		
		logger $test" check"
fi

}

str_col=$(grep -cv "^#" $home_trbot"temp_del.txt")
logger "str_col="$str_col

for (( i=1;i<=$str_col;i++)); do
	rm -f $home_trbot"in_id2.txt"
	test=$(sed -n $i"p" $home_trbot"temp_del.txt" | tr -d '\r')
	logger "del_id="$test
	deleteler;
done

echo "delete "$state", jobs now:" > $home_trbot"del.txt"	
cat $home_trbot"alerts2.txt" >> $home_trbot"del.txt"
echo "----" >> $home_trbot"del.txt"

cat $home_trbot"del.txt"


