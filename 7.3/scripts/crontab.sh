#!/bin/bash

if [ ! "$PHP_CRONTABS_PATH" == "" ]; then
	printf "env CRONTABS_PATH: setting up crontabs: ";
	for f in ${PHP_CRONTABS_PATH}; do
		printf "$f, ";
		rm -f /etc/cron.d/${f##*/}
		cp $f /etc/cron.d/
		chmod 0644 /etc/cron.d/${f##*/}
	done
	echo
	touch /var/log/cron.log
	printenv | grep -v "no_proxy" >> /etc/default/locale
	/etc/init.d/cron start > /dev/null
fi
