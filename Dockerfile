FROM php:5-fpm

RUN apt-get -qq update -y && DEBIAN_FRONTEND=noninteractive  apt-get -qq install -y --no-install-recommends \
    libldap2-dev \
    libxml2-dev \
    libssl-dev \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    libmagickwand-dev \
    imagemagick \
    nano

RUN set -ex && pecl install \
    memcache \
    imagick \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install mbstring soap ldap \
    && docker-php-ext-enable memcache imagick

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear
