FROM php:7-fpm

ENV PHPREDIS_VERSION 3.1.6
ENV PHPUNIT_VERSION 7.0.0

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
    libmemcached-dev \
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

RUN set -ex && pecl install imagick memcached \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install mbstring soap ldap redis \
    && docker-php-ext-enable imagick memcached

# Add php code style support
ADD http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar /usr/local/bin/php-cs-fixer
ADD https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar /usr/local/bin/phpcs
ADD https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar /usr/local/bin/phpcbf
ADD CodeSniffer.conf /usr/local/bin/CodeSniffer.conf
ADD https://phar.phpunit.de/phpunit-$PHPUNIT_VERSION.phar /usr/local/bin/phpunit
# Parallel-lint boxed locally: https://github.com/JakubOnderka/PHP-Parallel-Lint#create-phar-package
ADD parallel-lint.phar /usr/local/bin/phplint
RUN chmod 755 /usr/local/bin/php-cs-fixer \
              /usr/local/bin/phpcs \
              /usr/local/bin/phpcbf \
              /usr/local/bin/phplint \
              /usr/local/bin/phpunit \
              /usr/local/bin/CodeSniffer.conf

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/pear
