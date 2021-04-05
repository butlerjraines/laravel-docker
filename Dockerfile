FROM ubuntu:latest
#the following ARG turns off the questions normally asked for location and timezone for Apache
ENV DEBIAN_FRONTEND=noninteractive
#install all the tools you might want to use in your container
#probably should change to apt-get install -y --no-install-recommends
RUN apt-get update
RUN apt upgrade -y
RUN apt-get install git -y
RUN apt-get install zip unzip -y
RUN apt-get install -y apache2
RUN apt-get install libapache2-mod-fcgid
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
# Laravel's index.php in in public.
RUN  sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf 

# Install PHP-fpm &onfigure Apache to use our PHP-FPM socket for all PHP files
RUN apt-get install -y \
 php7.4-fpm \
  php7.4-mbstring \
  php7.4-dom 
RUN a2enconf php7.4-fpm
RUN phpenmod opcache 
RUN phpenmod pdo
RUN phpenmod bcmath 
     
RUN chmod -R 777 var/www/html

# Now start the server
# Start PHP-FPM worker service and run Apache in foreground
EXPOSE 80
CMD service php7.4-fpm start && /usr/sbin/apache2ctl -D FOREGROUND
