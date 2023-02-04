#! /bin/sh

a=$(defaults read -g AppleInterfaceStyle 2>/dev/null | grep Dark | wc -l)

while true
do
	x=$(defaults read -g AppleInterfaceStyle 2>/dev/null | grep Dark | wc -l)

	if [[ $a != $x ]]; then
		kill -s USR1 $1
		echo "Sent SIGUSR1 to $1"
		a=$x
	fi
	
	sleep 2
done
