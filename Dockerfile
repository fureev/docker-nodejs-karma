FROM php:7-fpm

ENV PHPREDIS_VERSION 3.1.6

RUN apt-get -qq update -y && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
    unzip \
    libssl-dev \
    libpcre3 \
    libpcre3-dev \
    libldap2-dev \
    libxml2-dev \
    libssl-dev \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    libmagickwand-dev \
    imagemagick \
    nano

# Install memcache extension
RUN set -x \
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

# Get redis extension
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts

RUN set -ex && pecl install imagick \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install mbstring soap ldap redis \
    && docker-php-ext-enable imagick

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear
