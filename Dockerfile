FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpcre3-dev \
    $PHPIZE_DEPS \
 && docker-php-ext-install pdo pdo_mysql zip \
 && pecl install phalcon \
 && docker-php-ext-enable phalcon \
 && a2enmod rewrite \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80