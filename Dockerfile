FROM php:7.4-apache

# Установка дополнительных зависимостей и модулей
RUN a2enmod rewrite \
    && apt-get update \
    && apt-get install -y libzip-dev curl unzip git wget --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Установка драйвера PostgreSQL
RUN apt-get update  \
    && apt-get install -y libpq-dev  \
    && docker-php-ext-install pdo pdo_pgsql

# Установка Composer
RUN wget https://getcomposer.org/download/2.0.9/composer.phar \
    && mv composer.phar /usr/bin/composer && chmod +x /usr/bin/composer

# Копирование конфигурации Apache
COPY docker/apache.conf /etc/apache2/sites-enabled/000-default.conf

# Копирование entrypoint.sh
COPY docker/entrypoint.sh /entrypoint.sh

# Копирование исходного кода проекта
COPY . /var/www

# Установка разрешений на папки
#RUN chmod -R 777 /var/www/var/cache /var/www/var/log

WORKDIR /var/www

# Установка исполняемого флага для entrypoint.sh
RUN chmod +x /entrypoint.sh

# Запуск команды promtail для логирования
CMD ["apache2-foreground"]

# Установка entrypoint.sh в качестве точки входа
ENTRYPOINT ["/entrypoint.sh"]
