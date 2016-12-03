#!/usr/bin/env bash
set -euo pipefail
source /bd_build/buildconfig

curl -sL https://deb.nodesource.com/setup_6.x | bash -
$minimal_apt_get_install wget curl sudo git zsh nano libsqlite3-dev autoconf bison build-essential libssl-dev \
                libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev htop redis-server mariadb-server mariadb-client mercurial \
                ruby-dev rabbitmq-server realpath pkg-config unzip dnsutils re2c python-pip htop nodejs \
                python-dev libpq-dev tmux bzr libsodium-dev cmake default-jdk golang golang-race-detector-runtime python-setuptools

GOBIN=/usr/local/bin GOPATH=/tmp go get -v -u github.com/mailhog/MailHog
pip install --upgrade --no-cache-dir pip
cd /tmp && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.0.2.deb
dpkg -i /tmp/elasticsearch-5.0.2.deb
rm -f /tmp/elasticsearch-5.0.2.deb
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
