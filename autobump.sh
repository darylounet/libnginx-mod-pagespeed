#!/bin/bash

NPS_VERSION=`curl -s https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags |grep "name" |grep "stable" |head -1 |sed -n "s/^.*v\(.*\)-stable.*$/\1/p"`
NGINX_VERSION=`curl -s https://nginx.org/packages/mainline/ubuntu/dists/bionic/nginx/binary-amd64/Packages.gz|zcat |php -r 'preg_match_all("#Package: nginx\nVersion: (.*?)-\d~.*?\nArch#", file_get_contents("php://stdin"), $m);usort($m[1], "version_compare"); echo array_reverse($m[1])[0]."\n";'`

docker build --pull -t deb-dch -f Dockerfile-deb-dch .
docker run -it -v $PWD:/local -e HOME=/local deb-dch bash -c 'cd /local && \
    dch -M -v ${NPS_VERSION}+nginx-${NGINX_VERSION}-1~stretch --distribution "stretch" "Updated upstream."'

git add debian/changelog
git commit -m "Updated upstream."
git tag "pagespeed-${NPS_VERSION}/nginx-${NGINX_VERSION}"
git push origin --tags
#git push origin "pagespeed-${NPS_VERSION}/nginx-${NGINX_VERSION}"
