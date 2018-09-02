#!/bin/bash

### supervisord runs in nodaemon mode
### which means that this script has to be executed last in alphabetical filenames order
### as nothing will be executed after
if [ ! -z ${SUPERVISORD_PATH+x} ] && [ "$SUPERVISORD_PATH" != "" ]; then 
	echo "env SUPERVISORD: including configurations from: $SUPERVISORD_PATH"

	cp $SUPERVISORD_PATH /etc/supervisor/conf.d/

# overwrite default supervisord config to disable unix_http_server & supervisorctl
	export SUPERVISORD_CONF=/etc/supervisor/supervisord.conf

	echo "[supervisord]" > $SUPERVISORD_CONF
	echo "logfile=/var/log/supervisor/supervisord.log" >> $SUPERVISORD_CONF
	echo "childlogdir=/var/log/supervisor"  >> $SUPERVISORD_CONF
	echo "pidfile=/var/run/supervisord.pid" >> $SUPERVISORD_CONF
	echo "[rpcinterface:supervisor]" >> $SUPERVISORD_CONF
	echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> $SUPERVISORD_CONF
	echo "[include]" >> $SUPERVISORD_CONF
	echo "files = /etc/supervisor/conf.d/*.conf" >> $SUPERVISORD_CONF

# overwrite default healthcheck for supervisord
	echo '#!/bin/bash' > /healthcheck
	echo 'ps u -p $(cat /var/run/supervisord.pid) | grep supervisord > /dev/null || exit 1' >> /healthcheck
	chmod +x /healthcheck

# start supervisord
	/usr/bin/python /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

# IMPORTANT: allow write to supervisord.log by php-cli
# supervisord suspends next docker-boot steps
	chmod u+rw,g+rw,o+rw /var/log/supervisor/supervisord.log
	tail -f /var/log/supervisor/supervisord.log
fi
