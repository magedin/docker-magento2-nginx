FROM nginx:1.19
MAINTAINER MagedIn Technology <support@magedin.com>

RUN groupadd -g 1000 app \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN touch /var/run/nginx.pid
RUN mkdir /sock

RUN apt-get update && apt-get install -y \
  curl \
  libnss3-tools \
  openssl \
  vim \
  watch

#RUN mkdir /etc/nginx/certs \
#  && echo -e "\n\n\n\n\n\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt

#RUN ( \
#  cd /usr/local/bin/ \
#  && curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 -o mkcert \
#  && chmod +x mkcert \
#  )

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/conf.d/* /etc/nginx/conf.d/

RUN mkdir -p /etc/nginx/html /var/www/html \
  && chown -R app:app /etc/nginx /var/www /var/cache/nginx /var/run/nginx.pid /sock

USER app:app

VOLUME /var/www

WORKDIR /var/www/html
