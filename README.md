# Docker image for Laravel
PHP 7 Image ready for Laravel with node, bower and gulp

## Running the container

### Basic mode
#### Command line
```sh
$ docker run --name php -d -p 80:80 \
    -v "PATH_TO_VOLUME:/var/www/html" \
    virgilioneto/laravel-ready:latest
```

#### Docker compose
```yml
version: "3"
services:
  php:
    container_name: php
    image: virgilioneto/laravel-ready
    restart: unless-stopped
    volumes:
    - "PATH_TO_VOLUME:/var/www/html"
    ports:
    - "80:80"
```

### With XDebug
#### Command line
```sh
$ docker run --name php -d  -p 80:80 \
    -v "PATH_TO_VOLUME:/var/www/html" \
    -e "XDEBUG_CONFIG=remote_host=YOUR_MACHINE_IP_ADDRESS" \
    virgilioneto/laravel-ready:latest
```

#### Docker compose
```yml
version: "3"
services:
  php:
    container_name: php
    image: virgilioneto/laravel-ready
    restart: unless-stopped
    environment:
    - "XDEBUG_CONFIG=remote_host=YOUR_MACHINE_IP_ADDRESS"
    volumes:
    - "PATH_TO_VOLUME:/var/www/html"
    ports:
    - "80:80"
```