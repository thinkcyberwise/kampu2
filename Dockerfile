# Use official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html/

# Install PHPMailer via Composer
RUN composer require phpmailer/phpmailer

# Update Apache to listen on the Render-assigned port
RUN sed -i 's/Listen 80/Listen ${PORT}/g' /etc/apache2/ports.conf
RUN sed -i 's/:80/${PORT}/g' /etc/apache2/sites-available/000-default.conf

# Expose the port for Render
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
