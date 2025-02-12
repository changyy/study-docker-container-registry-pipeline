#!/bin/bash

# 替換環境變數
envsubst '${PHPFPM_HOST} ${PHPFPM_PORT}' < /etc/nginx/templates/app.conf.template > /etc/nginx/conf.d/app.conf

# 執行 CMD
exec "$@"
