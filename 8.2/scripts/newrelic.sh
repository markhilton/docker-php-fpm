#!/bin/bash

if [ ! -z ${NEWRELIC_LICENSE+x} ] && [ "$NEWRELIC_LICENSE" != "" ] ; then
    echo "env NEWRELIC_LICENSE: setting up newrelic license"
    sed -i -e "s/REPLACE_WITH_REAL_KEY/$NEWRELIC_LICENSE/" \
    -e "s/newrelic.appname[[:space:]]=[[:space:]].*/newrelic.appname=\"${NEWRELIC_APP_NAME}\"/" \
    $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini
    
else
    rm -f /usr/local/etc/php/conf.d/newrelic.ini
fi
