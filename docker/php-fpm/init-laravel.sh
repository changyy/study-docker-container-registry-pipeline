#!/bin/sh
cd /var/www/html

# 檢查 .env 是否存在，不存在則從 .env.example 複製
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
    php artisan key:generate --force
    # Just for testing
    touch /var/www/html/database/database.sqlite
elif [ -z "$(grep "^APP_KEY=" .env | grep -v "APP_KEY=$")" ]; then
    echo "Generating Laravel key..."
    php artisan key:generate --force
fi

# Laravel DB Migration
php artisan migrate

# 快取 Laravel 配置
php artisan config:cache
php artisan route:cache
php artisan view:cache
