FROM php:7.1-fpm

MAINTAINER Mark Hilton <nerd305@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev

RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mysqli pdo pdo_mysql

# install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# install the soap extension
RUN apt-get update -yqq && \
    apt-get -y install libxml2-dev && \
    docker-php-ext-install soap

# install Php Redis Extension
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# install the mongodb extension
RUN pecl install mongodb && \
    docker-php-ext-enable mongodb

# install bcmath, mbstring and zip extensions
RUN docker-php-ext-install bcmath && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip

# enable Exif PHP extentions requirements
RUN docker-php-ext-install exif

# tokenizer Modifications:
RUN docker-php-ext-install tokenizer

# install intl and requirements
RUN apt-get update -yqq && \
    apt-get install -y zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl

# install the ghostscript extension for PDF editing
RUN apt-get update -yqq \
    && apt-get install -y \
    poppler-utils \
    ghostscript

# LDAP:
RUN apt-get update -yqq && \
    apt-get install -y libldap2-dev && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN yes "" | pecl install msgpack-beta \
    && echo "extension=msgpack.so" > /usr/local/etc/php/conf.d/ext-msgpack.ini

# compile igbinary extension
RUN cd /tmp/ && git clone https://github.com/igbinary/igbinary "php-igbinary" && \
    cd php-igbinary && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    make clean && \
    docker-php-ext-enable igbinary

# curl extension
RUN apt-get install -y curl libcurl4-openssl-dev --no-install-recommends && \
    docker-php-ext-install curl

# data structures extension
RUN pecl install ds && \
    docker-php-ext-enable ds

# imagick
RUN apt-get update && apt-get install -y libmagickwand-6.q16-dev --no-install-recommends && \
    ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin && \
    pecl install imagick && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

# ssh2 module
RUN apt-get install -y libssh2-1-dev && \
    pecl install ssh2-1.0 && \
    docker-php-ext-enable ssh2

# php-module: curl dom bz2 gd json mysqli pcntl pdo pdo_mysql phar posix
RUN apt-get install -y libxml2-dev libbz2-dev re2c libpng++-dev \
    libjpeg-dev libvpx-dev zlib1g-dev libgd-dev \
    libtidy-dev libxslt1-dev libmagic-dev libexif-dev file \
    sqlite3 libsqlite3-dev libxslt-dev

RUN export CFLAGS="-I/usr/src/php" && \
    docker-php-ext-install xmlreader xmlwriter

RUN docker-php-ext-configure json && \
    docker-php-ext-configure session && \
    docker-php-ext-configure ctype && \
    docker-php-ext-configure tokenizer && \
    docker-php-ext-configure simplexml && \
    docker-php-ext-configure dom && \
    docker-php-ext-configure mbstring && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure pdo && \
    docker-php-ext-configure pdo_sqlite && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-configure iconv && \
    docker-php-ext-configure xml && \
    docker-php-ext-configure phar

RUN docker-php-ext-install \
    dom \
    bz2 \
    json \
    pcntl \
    phar \
    posix \
    simplexml \
    soap \
    tidy \
    xml \
    xmlrpc \
    xsl \
    calendar \
    ctype \
    fileinfo \
    ftp \
    sysvmsg \
    sysvsem \
    sysvshm    

# install the php memcache & memcached extension
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends unzip libssl-dev libpcre3 libpcre3-dev \
    && cd /tmp \
    && curl -sSL -o php7.zip https://github.com/websupport-sk/pecl-memcache/archive/php7.zip \
    && unzip php7 \
    && cd pecl-memcache-php7 \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/ext-memcache.ini \
    && rm -rf /tmp/pecl-memcache-php7 php7.zip

RUN curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p memcached \
    && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && ( \
        cd memcached \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-enable memcached

# mhash
RUN apt-get install -y libmhash2 libmhash-dev libc-client-dev libkrb5-dev

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN docker-php-ext-configure hash --with-mhash && \
    docker-php-ext-install hash

# Opcache
RUN docker-php-ext-install opcache

# install APCu
RUN pecl install apcu-5.1.8 && \
    pecl install apcu_bc-1.0.3 && \
    docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini && \
    docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

# install MSSQL support
# install ODBC driver
RUN apt-get update -y && apt-get install -y apt-transport-https locales gnupg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    export DEBIAN_FRONTEND=noninteractive && apt-get update -y && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql unixodbc-dev
RUN set -xe \
    && pecl install pdo_sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv \
    && apt-get purge -y unixodbc-dev && apt-get autoremove -y && apt-get clean

# set locale to utf-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# geoip - DEPRECIATED: using provided by Nginx container
# RUN runtimeRequirements="libgeoip-dev" \
#    && apt-get update && apt-get install -y ${runtimeRequirements} \
#    && pecl install geoip-1.1.1 \
#    && printf "extension=geoip.so\n[geoip]\ngeoip.custom_directory = /usr/share/GeoIP/\n" > /usr/local/etc/php/conf.d/ext-geoip.ini

# RUN mkdir -p /usr/share/GeoIP && cd /usr/share/GeoIP/ && \
#    rm -f GeoIP.dat GeoIPv6.dat && \
#    curl -L -O http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
#    curl -L -O http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && \
#    gzip -d * && \
#    mv GeoLiteCity.dat GeoIPCity.dat

#
#--------------------------------------------------------------------------
# Final Touches
#--------------------------------------------------------------------------
#

# install helpful libs
RUN apt-get -y install libfcgi0ldbl nano cron

# crontab fix: https://stackoverflow.com/questions/43323754/cannot-make-remove-an-entry-for-the-specified-session-cron
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/cron

# expose /status for health check & stop access log
RUN echo "pm.status_path = /status" >> /usr/local/etc/php/conf.d/zz-docker.conf && \
    echo "ping.path      = /ping"   >> /usr/local/etc/php/conf.d/zz-docker.conf && \
    echo "ping.response  = OK"      >> /usr/local/etc/php/conf.d/zz-docker.conf && \
    echo "access.log     = /proc/self/fd/1" >> /usr/local/etc/php/conf.d/zz-docker.conf

# composer 
# consider removing to a separate container
# RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
# ENV PATH="$PATH:/root/.composer/vendor/bin"

# install modman
# RUN curl -s -L https://raw.github.com/colinmollenhour/modman/master/modman-installer | bash && \
#     mv ~/bin/modman /usr/sbin/

# install NewRelic agent
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list && \
    curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5 newrelic-sysmond && \
    export NR_INSTALL_SILENT=1 && newrelic-install install

# install blackfire.io profiler
# RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
#     && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
#     && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
#     && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
#     && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# install SendGrid
RUN echo "postfix postfix/mailname string localhost" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install postfix libsasl2-modules -y

# install shared PHP code
RUN git clone https://github.com/nrk/predis.git /usr/local/lib/php/predis && \
    git clone https://github.com/markhilton/redis-http-cache.git /usr/local/lib/php/redis-http-cache

# Set default work directory
ADD scripts/* /usr/local/bin/
RUN chmod +x  /usr/local/bin/*

# install aliases
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /usr/local/bin/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc && \
    sed -i 's/\r//' /usr/local/bin/aliases.sh && \
    sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /usr/local/bin/aliases.sh

# Clean up
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Health check
HEALTHCHECK --interval=5s --timeout=3s \
    CMD SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

EXPOSE 9000
WORKDIR /app

CMD ["php-fpm"]
