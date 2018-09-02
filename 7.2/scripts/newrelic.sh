#!/bin/bash

if [ ! -z ${NEWRELIC_LICENSE+x} ] && [ "$NEWRELIC_LICENSE" != "" ] ; then 
	echo "env NEWRELIC_LICENSE: setting up newrelic license"
	sed -i "s/REPLACE_WITH_REAL_KEY/$NEWRELIC_LICENSE/g" /usr/local/etc/php/conf.d/newrelic.ini
	nrsysmond-config --set license_key=$NEWRELIC_LICENSE

	service newrelic-sysmond start > /dev/null

	chmod u+rw,g+rw,o+rw /var/log/newrelic/newrelic-daemon.log
else
	rm -f /usr/local/etc/php/conf.d/newrelic.ini
fi
