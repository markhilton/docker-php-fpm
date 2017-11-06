# Docker PHP-FPM images

Goal: Build out of the box, multi version, fully loaded PHP-FPM docker images, that can support all my projects. I mosty work with WordPress & Laravel. 
The images are no light weight. The aim is to support maximum number of features out of the box, that could be easily turn ON/OFF with environment setttings.

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

Supervisord support:
```
SUPERVISORD_PATH=/path/to/supervisor/configurations
```
will start supervisord daemon. Useful with frameworks like Laravel.
