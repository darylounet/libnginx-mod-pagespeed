#!/bin/bash

NPS_VERSION=`curl -s https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags |grep "name" |grep "stable" |head -1 |sed -n "s/^.*v\(.*\)-stable.*$/\1/p"`
NGINX_DEB_VERSION=`curl -s https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1`
NGINX_VERSION=`echo ${NGINX_DEB_VERSION} | cut -d'-' -f1`
NGINX_DEB_RELEASE=`echo ${NGINX_DEB_VERSION} | cut -d'-' -f2`

docker build -t build-nginx-pagespeed -f Dockerfile-deb \
    --build-arg DISTRIB=${OS} --build-arg RELEASE=${DIST} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg NGINX_DEB_RELEASE=${NGINX_DEB_RELEASE} \
    --build-arg NPS_VERSION=${NPS_VERSION} .
