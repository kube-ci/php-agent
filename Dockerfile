FROM debian:jessie

RUN set -x \
  && apt-get update \
  && apt-get -y --no-install-recommends install build-essential automake libtool ca-certificates git curl wget unzip gettext

RUN set -x \
  && apt-get install -y --no-install-recommends python-pip python-all-dev

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libgmp-dev \
    php-apc \
    php5 \
    php5-apcu \
    php5-cli \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-gmp \
    php5-imagick \
    php5-intl \
    php5-json \
    php5-ldap \
    php5-mcrypt \
    php5-pgsql \
  && sed -i 's/;date.timezone =/date.timezone ="UTC"/' /etc/php5/fpm/php.ini \
  && sed -i 's/;date.timezone =/date.timezone ="UTC"/' /etc/php5/cli/php.ini
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    php-pear \
    php5-dev \
    libsodium-dev \
    libyaml-dev \
    libgearman-dev
RUN set -x \
  && pip install pygments \
  && echo 'cgi.fix_pathinfo=0' >> /etc/php5/fpm/php.ini \
  && pecl install libsodium \
  && echo 'extension=libsodium.so' >> /etc/php5/fpm/php.ini \
  && echo 'extension=libsodium.so' >> /etc/php5/cli/php.ini \
  && pecl install yaml-1.3.0b1 \
  && echo 'extension=yaml.so' >> /etc/php5/fpm/php.ini \
  && echo 'extension=yaml.so' >> /etc/php5/cli/php.ini \
  && pecl install gearman-1.1.2 \
  && echo 'extension=gearman.so' >> /etc/php5/fpm/php.ini \
  && echo 'extension=gearman.so' >> /etc/php5/cli/php.ini

RUN set -x \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*
