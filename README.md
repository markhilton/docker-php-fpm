# PHP-FPM Docker Images
Docker container to install and run [PHP-FPM](https://php-fpm.org/).

## Project Goal
Build out of the box, multi version, fully loaded PHP-FPM docker images, that can support all my projects. I mosty work with WordPress & Laravel. 
The images are no light weight. The aim is to support maximum number of features out of the box, that could be easily turn ON/OFF with environment setttings.

## Supported branches and respective Dockerfile links

 - 7.2 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/7.2/Dockerfile)
 - 7.1 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/7.1/Dockerfile)
 - 5.6 [Dockerfile](https://github.com/markhilton/docker-php-fpm/blob/master/5.6/Dockerfile)

## What is PHP-FPM ?
PHP-FPM (FastCGI Process Manager) is an alternative FastCGI implementation for PHP.

## Environment variables

PHP-FPM user configuration, example:
```
PHP_USER=php-fpm
PHP_UID=1000
PHP_GID=1000
```
will run PHP-FPM daemon as php-fpm user with UID:GID set up as 1000:1000

Custom PHP extension ini configurations:
```
PHP_INI_PATH=/path/to/*.ini
```
will add additional path to include ini extension configurations.

Custom PHP-FPM pool configurations:
```
PHP_POOL_PATH=/path/to/*.conf
```
will add PHP-FPM pools from specified path.

Additional container boot scripts:
```
PHP_BOOT_SCRIPTS=/path/to/*.sh
```
will run scripts from specified path on container boot.

Support for crontabs:
```
PHP_CRONTABS_PATH=/path/to/cronttab_scripts
```
will install scripts located in `/path/to/cronttab_scripts` as crontabs and start crontab daemon inside container

NewRelic application monitoring support;
```
NEWRELIC_LICENSE=license_string
```
will turn on newrelic extension to monitor PHP application performance

SendGrid support:
```
SMTP_LOGIN=sendgrid_login
SMTP_PASSWORD=sendgrid_password
```
will update email routing via SendGrid. I use Google Cloud which blocks SMTP port 25 by default. 

PHP session handler to support Redis or Memcache:
```
PHP_SESSION_HANDLER=php_session_handler
PHP_SESSION_PATH=php_session_path
```
will update default PHP session handler. Useful with cluster environment, to allow shared PHP sessions between cluster participant instances.

## Installed extensions
- apc
- apcu
- bcmath
- bz2
- calendar
- Core
- ctype
- curl
- date
- dba
- dom
- ds
- enchant
- exif
- fileinfo
- filter
- ftp
- gd
- gettext
- gmp
- hash
- iconv
- igbinary
- imagick
- imap
- interbase
- intl
- json
- ldap
- libxml
- mbstring
- memcache
- memcached
- mongodb
- msgpack
- mysqli
- mysqlnd
- newrelic
- openssl
- pcntl
- pcre
- PDO
- pdo_dblib
- pdo_mysql
- pdo_pgsql
- pdo_sqlite
- pdo_sqlsrv
- pgsql
- Phar
- posix
- pspell
- readline
- recode
- redis
- Reflection
- session
- shmop
- SimpleXML
- soap
- sockets
- sodium
- SPL
- sqlite3
- ssh2
- standard
- sysvmsg
- sysvsem
- sysvshm
- test
- tidy
- tokenizer
- wddx
- xdebug
- xml
- xmlreader
- xmlrpc
- xmlwriter
- xsl
- Zend OPcache
- zip
- zlib

## Installed Zend Modules
- Xdebug
- Zend OPcache

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
    image: crunchgeek/php-fpm:7.2
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
