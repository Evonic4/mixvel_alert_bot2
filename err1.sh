#!/bin/bash

fhome=/usr/share/abot2/

promapi=$(sed -n 21"p" $fhome"settings.conf" | tr -d '\r')

curl -s --location --request POST $promapi \
--header 'Accept: application/json' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'query=sum(round(elcep_logs_matched_app_errors_all_client_request_errors2_total-avg_over_time(elcep_logs_matched_app_errors_all_client_request_errors2_total[1h])))/(sum(rate(http_requests_received_total{method!="HEAD",action!="", job="mixvel-gate-mixvel-api-metrics"}[1h]))*60*60*60)*100' | jq '.' > $fhome"err1.txt"


cat $fhome"err1.txt" | jq '.data.result[].value[1]' | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | awk '{printf("%.6f \n",$1)}' > $fhome"err.txt"
echo "----" >> $fhome"err.txt"
