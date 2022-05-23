#!/bin/bash

home_trbot=/usr/share/abot2/
vjob=$home_trbot"job.txt"
rm -f $vjob && touch $vjob

str_col=$(grep -cv "^#" $home_trbot"alerts2.txt")
echo "str_col="$str_col

echo "ID JOB" > $vjob
cat $home_trbot"alerts2.txt" >> $vjob

echo "----" >> $vjob
cat $vjob

