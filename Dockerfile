ARG MY_IMAGE
FROM $MY_IMAGE as stage1

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt update && apt install -y git zip

ARG ORG
ARG REPO
RUN git clone https://github.com/$ORG/$REPO
WORKDIR $REPO
RUN composer config --no-plugins allow-plugins.cyclonedx/cyclonedx-php-composer true
RUN COMPOSER_ALLOW_SUPERUSER=1 composer require --dev cyclonedx/cyclonedx-php-composer
RUN COMPOSER_ALLOW_SUPERUSER=1 composer make-bom -vv

FROM scratch as final-stage 
ARG REPO
COPY --from=stage1 $REPO/bom.xml .
