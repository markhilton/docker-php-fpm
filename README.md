# PHP-FPM Docker Images

Docker container to install and run [PHP-FPM](https://php-fpm.org/).

## Project Goal

Out of the box, multi-version, fully loaded PHP-FPM docker images, that can support all my PHP projects. I work with WordPress & Laravel.
The images are no light weight. The aim is to support maximum number of features out of the box, that could be easily turn ON/OFF with environment settings.

## Supported branches and respective Dockerfile links

-   7.4 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/7.4/Dockerfile)
-   7.3 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/7.3/Dockerfile)
-   7.2 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/7.2/Dockerfile)
-   7.1 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/7.1/Dockerfile)
-   5.6 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/5.6/Dockerfile)

## What is PHP-FPM ?

PHP-FPM (FastCGI Process Manager) is an alternative FastCGI implementation for PHP.

## Environment variables

Use following environment variables to configure docker container php process manager during container boot up:

### [system user](https://manpages.debian.org/stretch/adduser/adduser.8.en.html)

```bash
PHP_UID=1000
PHP_GID=1000
PHP_HOME=/app
PHP_USER=php-fpm
```

will run create a system user called `php-fpm` with UID:GUID 1000:1000 and home directory `/app`, which then can be referenced in your php-fpm manager pool configuration file.

### [php.ini configuration](http://php.net/manual/en/ini.php)

```bash
PHP_INI_PATH=/path/to/php.ini
```

will include specified `php.ini` configuration during php-fpm manager start. It allows to use a wildcard in case you would like to include several .ini configuration files.

### [php-fpm pool configurations](http://php.net/manual/en/install.fpm.configuration.php)

```bash
PHP_POOL_PATH=/path/to/pool.conf
```

will include specified `pool.conf` configuration during php-fpm manager start. It allows to use a wildcard in case you would like to include several .conf configuration files.
**ATTENTION:** default `www.conf` pool configuration will be loaded, unless you specify path to your custom `www.conf`.

### boot scripts

```bash
PHP_BOOT_SCRIPTS=/path/to/*.sh
```

will run scripts or a single script from specified path during container boot, before php-fpm manager starts up. Useful in cases when you want to include several pools configurations, where each pool uses a different system user (shared hosting). In those cases you would need to create each system user before php-fom manager starts up. `PHP_BOOT_SCRIPTS` could be use to point to a bash script that will create those system users.

### [crontabs](http://crontab.org/)

```bash
PHP_CRONTABS_PATH=/path/to/cronttab_scripts
```

will install a crontab defined in `/path/to/cronttab_scripts` and start crontab daemon inside container.

**example Laravel crontab**

```bash
#
# Laravel task scheduler
#
# ATTENTION:
# crontab sh shell requires:
# - a full path to php cli interpreter
# - current dir change to laravel artisan
# - an empty line is required at the end of this file for a valid cron file

* * * * * php-cli   cd /app && /usr/local/bin/php artisan schedule:run
```

### [NewRelic APM](https://docs.newrelic.com/docs/agents/php-agent/getting-started/introduction-new-relic-php)

```bash
NEWRELIC_LICENSE=license_string
```

will turn on NewRelic extension to monitor PHP application performance.

### [SendGrid](https://sendgrid.com/)

starting from latest 7.3 container the Sendgrid login & password credentials are deprecated in favor of API key.

_deprecated:_

```bash
SMTP_LOGIN=sendgrid_login
SMTP_PASSWORD=sendgrid_password
```

_in favor of API key:_

```bash
SENDGRID_API_KEY=api_key_string
```

will update default email routing via SendGrid. Google Cloud blocks SMTP port 25 by default, so this could be useful solution to set up an alternative email routing before php-fpm manager starts up.

```bash
TEST_EMAIL=email@domain.com
```

if set, on container boot the test script will send an email using PHP mail function to given recipient address.

### [session handler](http://php.net/manual/en/class.sessionhandler.php)

to support Redis or Memcached PHP session handler.

```bash
PHP_SESSION_HANDLER=php_session_handler
PHP_SESSION_PATH=php_session_path
```

will update default PHP session handler. Useful in cluster environments, to allow shared PHP sessions between cluster instances.

**[Example Redis session]**(https://www.digitalocean.com/community/tutorials/how-to-set-up-a-redis-server-as-a-session-handler-for-php-on-ubuntu-14-04)

```bash
PHP_SESSION_HANDLER=redis
PHP_SESSION_PATH=tcp://redis.host:6379
```

This will set php.ini global session handler to use Redis server accessible at
`redis.host` DNS endpoint name and port 6379.

**[Example Memcached session]**(https://www.digitalocean.com/community/tutorials/how-to-share-php-sessions-on-multiple-memcached-servers-on-ubuntu-14-04)

```bash
PHP_SESSION_HANDLER=memcached
PHP_SESSION_PATH=memcached.host:11211
```

This will set php.ini global session handler to use Memcached server accessible at `memcached.host` DNS endpoint name and port 11211.

### [Supervisord](http://supervisord.org/)

```bash
SUPERVISORD_PATH=/path/to/supervisord.conf
```

Allows to control and monitor multiple processes running inside the container. Example use case: ensure that there are minimum 8 simultaniously run Laravel Queues available at any time to process scheduled tasks.

Note that if you use supervisord the container boot script will create a `/healthcheck` file to monitor supervisord main process, which can be used to monitor container health. This example configuration for `docker-compose.yaml` will ensure that container does not exit after boot and redirect supervisord logs into stdout.

```bash
    command: [ "tail", '-f', '/var/log/supervisor/supervisord.log' ]
    healthcheck:
      test: /healthcheck
      retries: 3
      timeout: 5s
      interval: 5s
```

### php access log (on|off)

```bash
PHP_ACCESS_LOG=off
```

turns on|off php access log to docker container stdout.

### php error log (on|off)

```bash
PHP_ERROR_LOG=on
```

turns on|off php error log to docker container stdout.

## Installed extensions

-   apc
-   apcu
-   bcmath
-   bz2
-   calendar
-   Core
-   ctype
-   curl
-   date
-   dba
-   dom
-   ds
-   enchant
-   exif
-   fileinfo
-   filter
-   ftp
-   gd
-   gettext
-   gmp
-   hash
-   iconv
-   igbinary
-   imagick
-   imap
-   interbase
-   intl
-   json
-   ldap
-   libxml
-   mbstring
-   memcache
-   memcached
-   mongodb
-   msgpack
-   mysqli
-   mysqlnd
-   newrelic
-   openssl
-   pcntl
-   pcre
-   PDO
-   pdo_dblib
-   pdo_mysql
-   pdo_pgsql
-   pdo_sqlite
-   pdo_sqlsrv
-   pgsql
-   Phar
-   posix
-   pspell
-   readline
-   recode
-   redis
-   Reflection
-   session
-   shmop
-   SimpleXML
-   soap
-   sockets
-   sodium
-   SPL
-   sqlite3
-   ssh2
-   standard
-   sysvmsg
-   sysvsem
-   sysvshm
-   test
-   tidy
-   tokenizer
-   wddx
-   xdebug
-   xml
-   xmlreader
-   xmlrpc
-   xmlwriter
-   xsl
-   Zend OPcache
-   zip
-   zlib

## Installed Zend Modules

-   Xdebug
-   Zend OPcache

## Pull latest image

```sh
docker pull crunchgeek/php-fpm:7.2
```

## Running PHP apps

### Running image

Run the PHP-FPM image, mounting a directory from your host.

```sh
docker run -it --name php-fpm -v /path/to/your/app:/app crunchgeek/php-fpm:7.2 php script.php
```

or using [Docker Compose](https://docs.docker.com/compose/):

```sh
version: '3'
services:
  php-fpm:
    container_name: php-fpm
    image: crunchgeek/php-fpm:7.3
    entrypoint: php index.php
    volumes:
      - /path/to/your/app:/app
```

### Running as server

```sh
docker run --rm --name php-fpm -v /path/to/your/app:/app -p 8000:8000 crunchgeek/php-fpm:7.2 php -S 0.0.0.0:8000 /app/index.php
```

### Logging

```sh
docker logs php-fpm
```

# Listing installed extensions

```sh
docker run --rm -it crunchgeek/php-fpm:7.2 php -m
```

# Release Notes

## PHP-FPM 7.4

Extensions that failed to build from 7.3 to [7.4](https://www.php.net/ChangeLog-7.php):

-   mhash (Implemented RFC: The hash extension is now an integral part of PHP and cannot be disabled)
-   interbase (Unbundled the InterBase extension and moved it to PECL)
-   recode (Unbundled the recode extension)
-   wddx (Deprecated and unbundled the WDDX extension)
-   docker-php-ext-configure gd --with-png [only PNG](https://github.com/docker-library/php/issues/912)
