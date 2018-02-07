#!/bin/bash

### update PHP session handler
if [ ! -z ${PHP_SESSION_HANDLER+x} ] && [ ! -z ${PHP_SESSION_PATH+x} ] && [ "$PHP_SESSION_HANDLER" != "" ] && [ "$PHP_SESSION_PATH" != "" ]; then 
	echo "env PHP_SESSION_HANDLER: updating php session handler [ $PHP_SESSION_PATH ]"
	echo "session.save_handler = $PHP_SESSION_HANDLER"   > /usr/local/etc/php/conf.d/zz-session.ini
	echo "session.save_path    = \"$PHP_SESSION_PATH\"" >> /usr/local/etc/php/conf.d/zz-session.ini
fi
