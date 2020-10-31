
Dockerfiles for building libnginx-mod-pagespeed for Debian / Ubuntu

[![packagecloud deb packages](https://img.shields.io/badge/deb-packagecloud.io-844fec.svg)](https://packagecloud.io/DaryL/libnginx-mod-pagespeed-mainline) [![Build Status](https://travis-ci.org/darylounet/libnginx-mod-pagespeed.svg?branch=mainline)](https://travis-ci.org/darylounet/libnginx-mod-pagespeed)

If you're just interested in installing built packages, go there :
https://packagecloud.io/DaryL/libnginx-mod-pagespeed

Instructions : https://packagecloud.io/DaryL/libnginx-mod-pagespeed/install#manual-deb


If you want to build packages by yourself, this is for you :

DCH Dockerfile usage (always use stretch as it is replaced before build) :

```bash
docker build -t deb-dch -f Dockerfile-deb-dch .
docker run -it -v $PWD:/local -e HOME=/local deb-dch bash -c 'cd /local && \
dch -M -v 1.13.35.2+nginx-1.19.4-1~stretch --distribution "stretch" "Updated upstream."'
```

Build Dockerfile usage :

```bash
docker build -t build-nginx-pagespeed -f Dockerfile-deb \
--build-arg DISTRIB=debian --build-arg RELEASE=stretch \
--build-arg NGINX_VERSION=1.19.4 --build-arg NPS_VERSION=1.13.35.2 .
```

Or for Ubuntu :
```bash
docker build -t build-nginx-pagespeed -f Dockerfile-deb \
--build-arg DISTRIB=ubuntu --build-arg RELEASE=xenial \
--build-arg NGINX_VERSION=1.19.4 --build-arg NPS_VERSION=1.13.35.2 .
```

Then :
```bash
docker run build-nginx-pagespeed
docker cp $(docker ps -l -q):/src ~/Downloads/
```

And once you don't need it anymore :
```bash
docker rm $(docker ps -l -q)
```

Get latest ngx_pagespeed version : https://github.com/apache/incubator-pagespeed-ngx/releases
Or :
```bash
curl -s https://api.github.com/repos/apache/incubator-pagespeed-ngx/tags |grep "name" |grep "stable" |head -1 |sed -n "s/^.*v\(.*\)-stable.*$/\1/p"
```

Get latest nginx version : https://nginx.org/en/download.html
Or :
```bash
curl -s https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1| cut -d'-' -f1
```
