FROM debian:jessie

RUN set -x \
  && apt-get update \
  && apt-get -y --no-install-recommends install build-essential automake libtool ca-certificates git curl wget unzip gettext

RUN set -x \
  && apt-get install -y --no-install-recommends python-pip python-all-dev

RUN set -x \
  && wget -O - https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
  && echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    php7.0 \
    php7.0-apcu \
    php7.0-cli \
    php7.0-curl \
    php7.0-fpm \
    php7.0-gd \
    php7.0-gmp libgmp-dev \
    php7.0-imagick \
    php7.0-intl \
    php7.0-json \
    php7.0-ldap \
    php7.0-mcrypt \
    php7.0-pgsql \
    php7.0-mbstring \
    php7.0-sqlite3 \
  && sed -i 's/;date.timezone =/date.timezone ="UTC"/' /etc/php/7.0/fpm/php.ini \
  && sed -i 's/;date.timezone =/date.timezone ="UTC"/' /etc/php/7.0/cli/php.ini

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    php-pear \
    php7.0-dev

RUN set -x \
  && pecl install channel://pecl.php.net/apcu_bc-1.0.3 \
  && echo "extension=apc.so" | tee /etc/php/7.0/mods-available/apcu_bc.ini \
  && ln -sf /etc/php/7.0/mods-available/apcu_bc.ini /etc/php/7.0/cli/conf.d/20-apcu_bc.ini \
  && ln -sf /etc/php/7.0/mods-available/apcu_bc.ini /etc/php/7.0/fpm/conf.d/20-apcu_bc.ini

RUN set -x \
  && apt-get install -y --no-install-recommends libyaml-dev \
  && pecl install yaml-beta \
  && echo "extension=yaml.so" | tee /etc/php/7.0/mods-available/yaml.ini \
  && ln -sf /etc/php/7.0/mods-available/yaml.ini /etc/php/7.0/cli/conf.d/20-yaml.ini \
  && ln -sf /etc/php/7.0/mods-available/yaml.ini /etc/php/7.0/fpm/conf.d/20-yaml.ini

RUN set -x \
  && apt-get install -y --no-install-recommends libgearman-dev \
  && mkdir -p /opt/gearman \
  && cd /opt/gearman \
  && wget https://github.com/wcgallego/pecl-gearman/archive/master.tar.gz \
  && tar zxvf master.tar.gz --strip-components=1 \
  && phpize \
  && ./configure \
  && make install \
  && cd / \
  && echo "extension=gearman.so" | tee /etc/php/7.0/mods-available/gearman.ini \
  && ln -sf /etc/php/7.0/mods-available/gearman.ini /etc/php/7.0/cli/conf.d/20-gearman.ini \
  && ln -sf /etc/php/7.0/mods-available/gearman.ini /etc/php/7.0/fpm/conf.d/20-gearman.ini

RUN set -x \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*
