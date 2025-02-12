FROM php:8.4-fpm

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libfcgi-bin \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安裝 PHP 擴展
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    opcache

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 設置工作目錄
WORKDIR /var/www/html

# 複製專案檔案
COPY www/ .

COPY docker/php-fpm/init-laravel.sh /usr/local/bin/init-laravel.sh
RUN chmod 775 /usr/local/bin/init-laravel.sh

# 安裝依賴
RUN composer install --no-dev --optimize-autoloader
RUN /usr/local/bin/init-laravel.sh

# 設置權限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# 複製 PHP 配置文件（注意這裡的路徑改變）
COPY docker/php-fpm/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

# 測試 PHP-FPM 健康
COPY docker/php-fpm/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod 777 /usr/local/bin/healthcheck.sh

EXPOSE 9000

CMD ["php-fpm"]
