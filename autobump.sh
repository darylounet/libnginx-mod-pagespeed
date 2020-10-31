#!/bin/bash

NPS_VERSION=`curl -s https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags |grep "name" |grep "stable" |head -1 |sed -n "s/^.*v\(.*\)-stable.*$/\1/p"`
NGINX_DEB_VERSION=`curl -s https://nginx.org/packages/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1`

docker build --pull -t deb-dch -f Dockerfile-deb-dch .
docker run -it -v $PWD:/local -e HOME=/local deb-dch bash -c "cd /local && \
    dch -M -v ${NPS_VERSION}+nginx-${NGINX_DEB_VERSION}~stretch --distribution 'stretch' 'Updated upstream.'"

git add debian/changelog
git commit -m "Updated upstream."
git tag "pagespeed-${NPS_VERSION}/nginx-${NGINX_DEB_VERSION}"
git push origin --tags
#git push origin "pagespeed-${NPS_VERSION}/nginx-${NGINX_DEB_VERSION}"
