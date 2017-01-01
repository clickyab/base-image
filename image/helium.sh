#!/usr/bin/env bash
set -euo pipefail
source /bd_build/buildconfig

apt update -y
$minimal_apt_get_install php-fpm php-mysql php php-memcached php-memcache php-redis  php-gd  php-cli php-json nginx
