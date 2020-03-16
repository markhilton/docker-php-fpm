#!/bin/bash

### update PHP session handler
if [ ! "$PHP_SESSION_HANDLER" == "" ] && [ ! "$PHP_SESSION_PATH" == "" ]; then
	echo "env PHP_SESSION_HANDLER: updating php session handler [ $PHP_SESSION_PATH ]"
	echo "session.save_handler = $PHP_SESSION_HANDLER"   > /usr/local/etc/php/conf.d/zz-session.ini
	echo "session.save_path    = \"$PHP_SESSION_PATH\"" >> /usr/local/etc/php/conf.d/zz-session.ini
fi
