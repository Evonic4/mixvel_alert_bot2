#!/bin/bash

fhome=/usr/share/abot2/

promapi=$(sed -n 25"p" $fhome"settings.conf" | tr -d '\r')

curl -s --location --request POST $promapi \
--header 'Accept: application/json' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'query=sum(rate(http_requests_received_total{method!="HEAD",action!="", job=~"mixvel-gate-mixvel-api-metrics"}[24h]))' | jq '.' > $fhome"rps1.txt"


cat $fhome"rps1.txt" | jq '.data.result[].value[1]' | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{printf("%.6f \n",$1)}' > $fhome"rps.txt"
echo "----" >> $fhome"rps.txt"

