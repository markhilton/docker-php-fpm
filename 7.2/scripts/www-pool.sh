#!/bin/bash

if [ ! -z ${PHP_INI_SCAN_DIR+x} ] && [ "$PHP_INI_SCAN_DIR" != "" ] ; then
   echo "env PHP_INI_SCAN_DIR: $PHP_INI_SCAN_DIR"

   ### check if there are any php pool configuration files to copy
   COUNT=`ls -1 *.conf 2>/dev/null | wc -l`

   if [ COUNT != 0 ] ; then
      cp -f $PHP_INI_SCAN_DIR/*.conf /usr/local/etc/php-fpm.d/
   fi
fi
