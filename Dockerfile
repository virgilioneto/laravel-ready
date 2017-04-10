FROM php:7.0-apache
MAINTAINER Virgilio Missão Neto <virgilio.missao.neto@gmail.com>

RUN apt-get update \
  && apt-get install -y \
  libpq-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng12-dev \
  zlib1g-dev \
  libicu-dev \
  libxml2-dev \
  libmemcached-dev \
  libssl-dev \
  curl \
  git-core \
  ruby \
  g++

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
  && docker-php-ext-install -j$(nproc) mbstring xml iconv mcrypt gd intl xmlrpc zip bcmath sockets pdo pdo_mysql zip pcntl

RUN curl -fsSL 'https://xdebug.org/files/xdebug-2.4.0.tgz' -o xdebug.tar.gz \
    && mkdir -p xdebug \
    && tar -xf xdebug.tar.gz -C xdebug --strip-components=1 \
    && rm xdebug.tar.gz \
    && ( \
    cd xdebug \
    && phpize \
    && ./configure --enable-xdebug \
    && make -j$(nproc) \
    && make install \
    ) \
    && rm -r xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash \
  && bash -i -c 'nvm install node' && bash -i -c 'nvm use node' \
  && bash -i -c 'npm install bower gulp -g'

COPY default-vhost.conf /etc/apache2/sites-available/default.conf
RUN a2dissite 000-default.conf && a2ensite default.conf && a2enmod rewrite

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
