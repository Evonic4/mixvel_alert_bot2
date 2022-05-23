#!/bin/bash

#telegramm bot rada INPUT
ftb=/usr/share/abot2/
fPID=$ftb"cu1_pid.txt"

#Z1=$1

if ! [ -f $fPID ]; then	
	PID=$$
	echo $PID > $fPID
	token=$(sed -n 1"p" $ftb"settings.conf" | tr -d '\r')
	proxy=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')

	if [ -z "$proxy" ]; then
		curl -k -s -L -m 13 https://api.telegram.org/bot$token/getUpdates > $ftb"in0.txt"
	else
		curl -k -s -m 13 --proxy $proxy -L https://api.telegram.org/bot$token/getUpdates > $ftb"in0.txt"
	fi

	mv $ftb"in0.txt" $ftb"in.txt"

fi
rm -f $fPID
