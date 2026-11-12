FROM php:8.3-cli-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev libonig-dev libpng-dev unzip git && docker-php-ext-install pdo_pgsql mbstring gd && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.json
COPY . .

RUN mkdir -p storage/app/private/covers storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs bootstrap/cache && chmod -R 777 storage bootstrap/cache && composer install --no-interaction --prefer-dist --no-progress

EXPOSE 8000

CMD ["sh", "-c", "php artisan migrate --force && php artisan app:provision-admin && php artisan serve --host=0.0.0.0 --port=8000"]
