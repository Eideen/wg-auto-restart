#!/usr/bin/env bash

SERVICE="wg-quick@wg0"
SLEEP=60
LIMIT=3
HOST="fd00::1:0"

echo "starting"

COUNT=0
while true; do
	if $(ping -c1 $HOST 2>&1 > /dev/null); then
	echo "ping $HOST succesfull"
	COUNT=0
	else
	((COUNT++))
	echo "ping $HOST unreachable, $COUNT"
	fi
	if [[ $COUNT -ge $(($LIMIT + 20 )) ]]; then
	 echo "rebooting"
   reboot
	elif [[ $COUNT -ge $LIMIT ]]; then
		echo "restarting ${SERVICE}"
	  systemctl restart "${SERVICE}.service"
	  sleep $(($SLEEP * 4))

	fi
	sleep $SLEEP
done
