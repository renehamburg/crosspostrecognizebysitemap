#!/bin/bash

CACHE_PATH=~/.cache/hugo-crosspost-cache
URL="https://add.here.your.URL/sitemap.xml"


if [ ! -d ${CACHE_PATH} ] ; then
 echo "mkdir -p ${CACHE_PATH}"
 mkdir ${CACHE_PATH}
fi

mv ${CACHE_PATH}/current ${CACHE_PATH}/latest
wget -q -O ${CACHE_PATH}/current ${URL}

DIFF=$(diff ${CACHE_PATH}/current ${CACHE_PATH}/latest)

if ! diff ${CACHE_PATH}/current ${CACHE_PATH}/latest > /dev/null 2>&1
then

 POST=$(diff ${CACHE_PATH}/current ${CACHE_PATH}/latest | grep "<loc>" | sed s/\>/\ /g | sed s/\</\ /g|awk '{print $2}')
 TITEL=$(wget -qO- ${POST}| perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si')
 
 echo "Sending toot: 'hey; neuer Artikel ${TITEL} im Blog! #blogpost $POST'"
 toot 'hey; neuer Artikel ${TITEL} im Blog! #blogpost $POST'
fi
