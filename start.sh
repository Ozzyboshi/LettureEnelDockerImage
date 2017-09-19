#!/bin/bash
echo "param 1 is "
echo "$1"
echo "all args"
echo $@

if [ "$1" == "secureonly" ]; then
	echo "entro"
	a2dissite 000-default.conf
	a2ensite default-ssl.conf
elif [ "$1" == "insecureonly" ]; then
	a2dissite default-ssl.conf
	a2ensite 000-default.conf
else
	a2ensite default-ssl.conf
	a2ensite 000-default.conf
fi
/usr/sbin/apache2ctl -D FOREGROUND
