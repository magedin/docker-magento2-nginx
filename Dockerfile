FROM nginx:1.21.0
MAINTAINER MagedIn Technology <support@magedin.com>


# ENVIRONMENT VARIABLES ------------------------------------------------------------------------------------------------

ENV APP_USER     www
ENV APP_GROUP    ${APP_USER}
ENV APP_HOME     /var/${APP_USER}
ENV APP_ROOT     ${APP_HOME}/html

ENV SSL_DIR      ${APP_HOME}/ssl
ENV SSL_CA_DIR   ${SSL_DIR}/ca
ENV SSL_CERT_DIR ${SSL_DIR}/certificates
ENV CAROOT       ${SSL_CA_DIR}


# BASE INSTALLATION ----------------------------------------------------------------------------------------------------

RUN groupadd -g 1000 ${APP_USER} \
 && useradd -g 1000 -u 1000 -d ${APP_HOME} -s /bin/bash ${APP_GROUP}

RUN touch /var/run/nginx.pid
RUN mkdir /sock

RUN apt-get update && apt-get install -y \
  curl \
  libnss3-tools \
  openssl \
  vim \
  lsof \
  watch

#RUN mkdir /etc/nginx/certs \
#  && echo -e "\n\n\n\n\n\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt

RUN ( \
  cd /usr/local/bin/ \
  && curl -Lk http://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 -o mkcert \
  && chmod +x mkcert \
)


# BASE CONFIGURATION ---------------------------------------------------------------------------------------------------

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/conf.d/* /etc/nginx/conf.d/

RUN mkdir -p /etc/nginx/html \
  ${APP_ROOT} \
  ${SSL_CA_DIR} \
  ${SSL_CERT_DIR}

RUN chown -R ${APP_USER}:${APP_GROUP} \
  /etc/nginx \
  ${APP_HOME} \
  ${SSL_CA_DIR} \
  ${SSL_CERT_DIR} \
  /var/cache/nginx \
  /var/run/nginx.pid \
  /sock

VOLUME ${APP_HOME}

WORKDIR ${APP_ROOT}
