#!/usr/bin/env bash
set -euo pipefail
source /bd_build/buildconfig

apt-get update
$minimal_apt_get_install wget curl sudo git zsh nano libsqlite3-dev autoconf bison build-essential libssl-dev \
                libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev htop redis-server mariadb-server  mercurial \
                ruby-dev rabbitmq-server realpath pkg-config unzip dnsutils re2c python-pip redis-server php-gettext \
                python-dev libpq-dev tmux bzr cmake default-jdk golang mariadb-client imagemagick php7.0-dev \
                graphicsmagick php7.0-cli php7.0-fpm php7.0-json php7.0-intl php7.0-curl php7.0-mysql \
                php7.0-mcrypt php7.0-gd php7.0-sqlite3 php7.0-ldap php7.0-opcache php7.0-xmlrpc php7.0-xsl \
                php7.0-bz2 php7.0-zip php7.0-soap php7.0-bcmath php7.0-mbstring php-apcu nginx-extras \

git clone https://github.com/phpredis/phpredis.git /tmp/phpredis
cd /tmp/phpredis
git checkout php7
phpize
./configure
make
make install
echo "extension=redis.so" >/etc/php/7.0/mods-available/redis.ini
cd /etc/php/7.0/cli/conf.d && ln -s ../../mods-available/redis.ini 30-redis.ini
cd /etc/php/7.0/fpm/conf.d && ln -s ../../mods-available/redis.ini 30-redis.ini

GOBIN=/usr/local/bin GOPATH=/tmp go get -v -u github.com/mailhog/MailHog

# Create vagrant user
bash -c "echo root:bita123 | chpasswd"
groupadd develop
useradd -g develop -m -s /usr/bin/zsh develop
bash -c "echo %develop ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant"
chmod 0440 /etc/sudoers.d/vagrant
bash -c "echo develop:bita123 | chpasswd"
sudo -Hu develop -- wget -O /home/develop/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
sudo -Hu develop -- wget -O /home/develop/.zshrc.local  http://git.grml.org/f/grml-etc-core/etc/skel/.zshrc

# Go related stuff
bash -c "echo export GOPATH=/home/develop >> /etc/environment"
sudo -Hu develop -- bash -c "echo export GOPATH=/home/develop >> /home/develop/.zshrc.local"
sudo -Hu develop -- bash -c "echo export PATH=$PATH:/usr/local/go/bin:/home/develop/bin >> /home/develop/.zshrc.local"
