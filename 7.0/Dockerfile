FROM php:7.0-fpm

MAINTAINER Mark Hilton <nerd305@gmail.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev

RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install the PHP gd library
RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# Install the soap extension
RUN apt-get update -yqq && \
    apt-get -y install libxml2-dev && \
    docker-php-ext-install soap

# Install Php Redis Extension
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Install the mongodb extension
RUN pecl install mongodb && \
    docker-php-ext-enable mongodb

# Install bcmath, mbstring and zip extensions
RUN docker-php-ext-install bcmath && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip

# Enable Exif PHP extentions requirements
RUN docker-php-ext-install exif

# Tokenizer Modifications:
RUN docker-php-ext-install tokenizer

# Install intl and requirements
RUN apt-get update -yqq && \
    apt-get install -y zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl

# Install the ghostscript extension for PDF editing
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

# Compile igbinary extension
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
                      libpng3 libjpeg-dev libvpx-dev zlib1g-dev libgd-dev \
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

# Install the php memcache & memcached extension
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
RUN apt-get install -y libmhash2 libmhash-dev && \
    cd /usr/src/ && \
    curl -O -L https://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz && \
    tar xzf mhash-0.9.9.9.tar.gz && \
    cd mhash-0.9.9.9 && \
    ./configure && make && make install && \
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2

RUN docker-php-ext-configure hash --with-mhash=/usr/src/mhash-0.9.9.9/ && \
    docker-php-ext-install hash

# Opcache
RUN docker-php-ext-install opcache

# Install APCu
RUN pecl install apcu-5.1.8 && \
    pecl install apcu_bc-1.0.3 && \
    docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini && \
    docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

#
#--------------------------------------------------------------------------
# Final Touches
#--------------------------------------------------------------------------
#

RUN apt-get -y install libfcgi0ldbl jq nano supervisord git mysql-client cron redis-tools

# composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# install modman
RUN curl -s -L https://raw.github.com/colinmollenhour/modman/master/modman-installer | bash && \
    mv ~/bin/modman /usr/sbin/

# install NewRelic agent
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list && \
    curl https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install newrelic-php5 newrelic-sysmond && \
    export NR_INSTALL_SILENT=1 && newrelic-install install

# install SendGrid
RUN echo "postfix postfix/mailname string localhost" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install postfix libsasl2-modules -y

# install blackfire.io profiler
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# Install shared PHP code
RUN git clone https://github.com/nrk/predis.git /usr/local/lib/php/predis && \
    git clone -b magento https://github.com/markhilton/redis-http-cache.git /usr/local/lib/php/redis-http-cache

# Set default work directory
ADD scripts/* /usr/local/bin/
RUN chmod +x  /usr/local/bin/*

# Clean up
RUN apt-get remove -y php5-common && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Health check
HEALTHCHECK --interval=10s --timeout=5s \
    CMD SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm"]
