#! /bin/sh

a=$('qdbus org.freedesktop.portal.Desktop
          \ /org/freedesktop/portal/desktop
          \ org.freedesktop.portal.Settings.Read
          \ "org.freedesktop.appearance" "color-scheme"')

while true
do
	x=$('qdbus org.freedesktop.portal.Desktop
          \ /org/freedesktop/portal/desktop
          \ org.freedesktop.portal.Settings.Read
          \ "org.freedesktop.appearance" "color-scheme"')

	if [[ $a != $x ]]; then
		kill -s USR1 $1
		echo "Sent SIGUSR1 to $1"
		a=$x
	fi
	
	sleep 2
done
