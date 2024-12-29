# Docker-Wordpress v0.1 (still updated)
In this article, we will proceed to create a WordPress website through Docker Compose, Nginx, Apache, PHP 8.1, MariaDB and Let’s Encrypt on Ubuntu 22.04. And this setup is currently considered the most optimal combination and is being tested on Google Cloud with Ubuntu 22.04 operating system.

## Conditions the server needs to meet:
- Install Docker on Ubuntu 22.04
- Install Docker Compose on Ubuntu 22.04.
- The domain must be pointed to the server IP
  
Please ensure that you have fulfilled the above conditions.

If the above conditions are met, we will proceed to install and configure the WordPress website.

## Setup Instructions
- You should get the file "docker-compose.yml" and file "nginx.conf"
- The remaining files are because when docker runs, it automatically mounts data from the container to the outside, so each person will have different data.
  
### B1 First we create a file to contain our project.

mkdir docker-wp

### B2 into the docker-wp directory we will start creating files such as docker-compose.yml, nginx.conf,...

touch docker-compose.yml

mkdir nginx.conf

mkdir certbot

mkdir db_data

mkdir wordpress

That's it, then you can copy the file "docker-compose.yml" and folder "nginx.conf" to run.

## Note: in the nginx.conf folder there is a default.conf file, you should go there and edit your domain.
