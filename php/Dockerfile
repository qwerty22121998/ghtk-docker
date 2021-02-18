FROM php:7.1-fpm as base-php


RUN apt-get update -q

RUN apt-get install -qq -y \
  curl \
  git \
  zip \
  unzip \
  wget

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN install-php-extensions xdebug-2.9.8

RUN install-php-extensions redis-3.1.5

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

RUN install-php-extensions fileinfo pcntl

# RUN docker-php-ext-install fileinfo pcntl

FROM base-php as install-composer

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && ln -s $(composer config --global home) /root/composer

ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

FROM install-composer as install-gearman

RUN apt-get update -q

RUN apt-get install -f -y  supervisor gearman-tools

RUN apt-get -y --allow-unauthenticated install libgearman-dev 

RUN apt-get install -y gearman-job-server 

RUN install-php-extensions gearman-2.1.0

FROM install-gearman as oh-my-zsh

ENV TERM xterm

RUN apt-get update -qq

RUN apt-get install -y zsh

RUN sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
  -t ys \
  -p https://github.com/zsh-users/zsh-syntax-highlighting \
  -p https://github.com/zsh-users/zsh-history-substring-search 

RUN apt-get remove -y git 

RUN echo 'run () {php -f /var/www/html/$1/app/Console/cake.php ${@:2}}' >> $HOME/.zshrc
RUN echo 'export PHP_IDE_CONFIG="serverName=Docker"' >> $HOME/.zshrc
RUN echo 'clear_gearman () {supervisorctl "stop all" && gearadmin --drop $1 && supervisorctl "start all" }' >> $HOME/.zshrc

FROM oh-my-zsh as other-dependency

#install your lib here


RUN apt-get update -qq

RUN mkdir -p /usr/share/man/man1

RUN apt-get install -y -q vim tmux default-jre

RUN apt-get install -y -q libgmp-dev && install-php-extensions gmp

RUN install-php-extensions yaml


RUN echo "set-option -g default-shell $SHELL" > ~/.tmux.conf



FROM other-dependency as entrypoint 

RUN echo -e "#!/bin/bash\nservice supervisor start\ngearmand -d\nphp-fpm" > start.sh

RUN chmod a+x start.sh

CMD [ "/var/www/html/start.sh" ]

