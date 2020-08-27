FROM php:7.1-fpm as base-php


RUN apt-get update -q

RUN apt-get install -qq -y \
  curl \
  git \
  zip \
  unzip \
  wget

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN pecl install -f redis-3.1.5 && docker-php-ext-enable redis

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN install-php-extensions \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  intl \
  ldap \
  mcrypt \
  mysqli \
  opcache \
  pdo_mysql \
  zip

RUN docker-php-ext-install fileinfo pcntl

# RUN \
#   curl 'http://pecl.php.net/get/redis-3.1.5.tgz' -o /tmp/redis-3.1.5.tgz  \
#   && cd /tmp \
#   && pecl install redis-3.1.5.tgz \
#   && rm -rf redis-3.1.5.tgz \
#   && docker-php-ext-enable redis

FROM base-php as install-composer

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && ln -s $(composer config --global home) /root/composer

ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

FROM install-composer as install-gearman

RUN apt-get update -q

RUN apt-get -y --allow-unauthenticated install libgearman-dev

RUN cd /tmp \
  && git clone https://github.com/wcgallego/pecl-gearman.git \
  && cd pecl-gearman \
  && git checkout gearman-2.0.3 \
  && phpize \
  && ./configure \
  && make -j$(nproc) \
  && make install \
  && rm -r /tmp/pecl-gearman \
  && docker-php-ext-enable gearman

RUN apt-get install -f -y  supervisor gearman-tools

RUN apt-get install -y gearman-job-server 

FROM install-gearman as oh-my-zsh

ENV TERM xterm

RUN apt-get update -qq

RUN apt-get install -y zsh

RUN sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
  -t ys \
  -p git \
  -p https://github.com/zsh-users/zsh-syntax-highlighting \
  -p https://github.com/zsh-users/zsh-history-substring-search 

FROM oh-my-zsh as other-dependency

#install your lib here

RUN apt-get update -qq

RUN apt-get install -y -q vim 


FROM other-dependency as entrypoint 

COPY ./start.sh start.sh

CMD [ "/var/www/html/start.sh" ]

