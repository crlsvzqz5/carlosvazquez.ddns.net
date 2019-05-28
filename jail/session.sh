#!/bin/bash
# Invoked automatically (by init_session.php --> enter_jail.sh --> here) after loading
# carlosvazquez.ddns.net. By the time this script is called, the new root / is actually
# /var/www/jail/ and all commands are run with root permission. This script first downgrades
# the permission by setting the UID, sets up pipes to communicate to php scripts outside of
# jail, and then begins the session by entering a simple read-eval-print loop.

sessionid=$1;

while true
do
	if read line </var/www/jail/fifo/${sessionid}_tobash; then
		if [[ "$line" == 'quit' ]]; then
			break
		fi
		${line} &> /var/www/jail/fifo/${sessionid}_tophp
	fi
done
echo "Finished" > /var/www/jail/fifo/${sessionid}_tophp