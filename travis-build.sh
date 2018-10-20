#!/bin/bash

NPS_VERSION=`curl -s https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags |grep "name" |grep "stable" |head -1 |sed -n "s/^.*v\(.*\)-stable.*$/\1/p"`
NGINX_VERSION=`curl -s https://nginx.org/packages/mainline/ubuntu/dists/bionic/nginx/binary-amd64/Packages.gz|zcat |php -r 'preg_match_all("#Package: nginx\nVersion: (.*?)-\d~.*?\nArch#", file_get_contents("php://stdin"), $m);usort($m[1], "version_compare"); echo array_reverse($m[1])[0]."\n";'`

docker build -t build-nginx-pagespeed -f Dockerfile-deb \
	--build-arg DISTRIB=${OS} --build-arg RELEASE=${DIST} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg NPS_VERSION=${NPS_VERSION} .
