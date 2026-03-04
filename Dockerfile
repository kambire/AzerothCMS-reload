FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libgmp-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    intl \
    gd \
    mysqli \
    zip \
    soap \
    gmp \
    mbstring \
    curl \
    bcmath \
    pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite headers expires deflate filter

# Set working directory
WORKDIR /var/www/html

# Adjust PHP settings for development
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Set Apache DocumentRoot to current dir
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Create necessary directories if they don't exist
RUN mkdir -p application/config application/modules \
    writable/cache writable/backups writable/logs writable/uploads

# Configure ownership and permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html \
    && chmod -R 777 /var/www/html/writable

# Expose port
EXPOSE 80

CMD ["apache2-foreground"]
