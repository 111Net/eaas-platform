#!/bin/bash

while true
do

/opt/eaas/scripts/healthcheck.sh \
>> /opt/eaas/logs/health.log

sleep 300

done
