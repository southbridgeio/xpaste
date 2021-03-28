#!/bin/sh

(crontab -l 2>/dev/null; echo "`cat /app/config/crontab`") | crontab - && \
printenv >> /etc/environment && \
crond -f
