FROM php:8.1-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpcre2-dev \
    $PHPIZE_DEPS \
 && docker-php-ext-install pdo pdo_mysql zip \
 && pecl install phalcon \
 && docker-php-ext-enable phalcon \
 && a2enmod rewrite \
 && sed -ri "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf \
 && sed -ri "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80