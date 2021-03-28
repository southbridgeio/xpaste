#!/bin/sh
set -ex
/app/bin/xpaste db create
/app/bin/xpaste db migrate
/app/bin/xpaste > /proc/1/fd/1 2>/proc/1/fd/2 & \
nginx -g 'daemon off;'
