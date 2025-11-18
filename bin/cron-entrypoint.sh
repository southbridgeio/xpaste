#!/bin/sh

(crontab -l 2>/dev/null; echo "`cat /rails/config/crontab`") | crontab - && \
crontab -l &&
printenv >> $HOME/.environment && \
crond -f
