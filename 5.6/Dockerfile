FROM php:5.6-fpm

MAINTAINER Mark Hilton <nerd305@gmail.com>

# Install PHP extensions
RUN DEBIAN_FRONTEND=noninteractive apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        nano openssl libldb-dev libtidy-dev libgmp-dev unixODBC-dev \
        libicu-dev \
        libmcrypt-dev \
        libcurl4-openssl-dev \
        librabbitmq-dev \
        libsodium-dev \
        libpq-dev \
        libxslt1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        zlib1g-dev \
        libgmp3-dev \
        libbz2-dev \
        libgmp-dev \
        libgmp3-dev

# imagic
RUN apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
    && pecl install imagick \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

RUN docker-php-ext-configure xsl \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
	&& docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install dba ftp calendar ctype dom tokenizer fileinfo gettext posix tidy wddx \
    && docker-php-ext-install exif sockets bz2 zip iconv mcrypt json session \
    && docker-php-ext-install opcache xsl xml xmlreader xmlwriter xmlrpc simplexml \
    && docker-php-ext-install curl bcmath intl pcntl mbstring soap mysqli pdo pdo_mysql \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && docker-php-ext-install gmp sysvmsg sysvsem sysvshm \
    && docker-php-ext-enable soap 

#    && docker-php-ext-configure odbc      --with-unixODBC=unixODBC,/usr/ \
#    && docker-php-ext-configure pdo_odbc  --with-pdo-odbc=unixODBC,/usr/ \
#    && docker-php-ext-install odbc pdo_odbc \
#    && docker-php-ext-enable odbc \

# mhash
RUN apt-get install -y libmhash2 libmhash-dev php5-mhash && \
    cd /usr/src/ && \
    curl -O -L https://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz && \
    tar xzf mhash-0.9.9.9.tar.gz && \
    cd mhash-0.9.9.9 && \
    ./configure && make && make install && \
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2

RUN docker-php-ext-configure hash --with-mhash=/usr/src/mhash-0.9.9.9/include/ && \
    docker-php-ext-install hash

# Igbinary module
RUN pecl install igbinary \
    && docker-php-ext-enable igbinary

RUN pecl install -o -f redis && \
	docker-php-ext-enable redis

RUN pecl install apcu-4.0.10 && \
    docker-php-ext-enable apcu

RUN apt-get install -y libmemcached-dev \
    && pecl install memcache \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcache memcached

RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p xcache \
    && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && ( \
        cd xcache \
        && phpize \
        && ./configure --enable-xcache \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xcache \
    && docker-php-ext-enable xcache

# composer
RUN RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# install NewRelic agent
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list && \
    curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5 newrelic-sysmond && \
    export NR_INSTALL_SILENT=1 && newrelic-install install

# Install required libraries
RUN apt-get -y install libfcgi0ldbl git mysql-client cron redis-tools

# install sendgrid mail routing
RUN echo "postfix postfix/mailname string localhost" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install postfix libsasl2-modules -y

# install modman
RUN curl -s -L https://raw.github.com/colinmollenhour/modman/master/modman-installer | bash && \
    mv ~/bin/modman /usr/sbin/

# install composer
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.5.2
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
 && php -r " \
    \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && rm -rf /tmp/* /tmp/.htaccess

# install recommended redis extension
RUN cd /usr/src && \
    git clone https://github.com/phpredis/phpredis.git && \
    cd /usr/src/phpredis && phpize && \
    ./configure --enable-redis-igbinary && \
    make && make install

# install blackfire.io profiler
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# cache
RUN echo 5

# Install shared PHP code
RUN git clone https://github.com/nrk/predis.git /usr/local/lib/php/predis && \
    git clone -b magento https://github.com/markhilton/redis-http-cache.git /usr/local/lib/php/redis-http-cache

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/* /usr/local/bin/

RUN chmod +x /usr/local/bin/*

# Health check
RUN sed -i '/pm.status_path/c\pm.status_path = /status' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i '/ping.path/c\ping.path = /health'           /usr/local/etc/php-fpm.d/www.conf && \
    sed -i '/ping.response/c\;ping.response = OK'       /usr/local/etc/php-fpm.d/www.conf

HEALTHCHECK --interval=10s --timeout=5s \
    CMD SCRIPT_NAME=/health SCRIPT_FILENAME=/health REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1
