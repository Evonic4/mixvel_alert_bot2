#!/bin/bash


fhome=/usr/share/abot2/

p1=$fhome"list_mail.txt"
p2=$fhome"mail.txt"


k1=$(wc -l $p1 | sed -r 's/ .+//' | sed 's/[ \t]*$//')	#кол-во строк
echo $k1


for (( i=2;i<=$k1;i++)); do
MSUBJ=$(sed -n "1p" $p2)
MBODY=$(sed -n "2p" $p2)
ATTACH=$(sed -n "3p" $p2 | tr -d '\r')
MADDR=$(sed -n $i"p" $p1 | tr -d '\r')

echo "отправка почты "$MADDR

if [ -z "$ATTACH" ]; then
echo $MBODY | mutt -s "$MSUBJ" $MADDR
else
echo $MBODY | mutt -s "$MSUBJ" -a $ATTACH -- $MADDR
fi

done

