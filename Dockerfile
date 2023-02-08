ARG MY_IMAGE
FROM $MY_IMAGE

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt update && apt install -y git
RUN echo '{"require": {"php": ">=7.2"}}' > composer.json
RUN composer config --no-plugins allow-plugins.cyclonedx/cyclonedx-php-composer true
RUN composer require --dev cyclonedx/cyclonedx-php-composer

RUN composer make-bom -vv

ENTRYPOINT ["/bin/bash"]

