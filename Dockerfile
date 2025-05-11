# Use the official Ubuntu 22.04 image as the base image
FROM ubuntu:22.04

# Set environment variables
ENV COMPOSER_VERSION=2.7.5

# Set environment variable to make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Configure time zone data to avoid interactive prompt
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Add PHP 7.4 repository (since Ubuntu 22.04 does not include PHP 7.4 by default)
#RUN add-apt-repository ppa:ondrej/php \
#    && apt-get update

# Install PHP 7.4 and required extensions
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-bcmath \
    php7.4-cgi \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-dba \
    php7.4-dev \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mcrypt \
    php7.4-mysql \
    php7.4-opcache \
    php7.4-xml \
    php7.4-xsl \
    php7.4-zip \
    php7.4-bz2 \
    php7.4-gd \
    php7.4-intl \
    php7.4-soap \
    libapache2-mod-php7.4 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

# Set the working directory
WORKDIR /var/www/html

COPY laravel .
RUN chown -R www-data:www-data /var/www/html && chmod -R 777 /var/www/html
RUN chown -R www-data:www-data /var/www/html/storage
RUN composer update --prefer-dist --no-interaction
RUN composer dump-autoload 
RUN php artisan config:clear \
    && php artisan config:cache \
    && php artisan route:clear \
    && php artisan route:cache \
    && php artisan optimize

RUN chown -R www-data:www-data /var/www/html && chmod -R 777 /var/www/html
RUN chown -R www-data:www-data /var/www/html/storage
# Expose port 8000 for Laravel development server
EXPOSE 8000


# Start the Laravel development server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
