#!/bin/sh

MYSQL_HOST=${MYSQL_HOST:-db}

cd /mnt/html
#rm -rf * .*
#mkdir git || exit 1
#mkdir content || exit 1
cp /data/nginx_config/* /mnt/nginx_config

if [ -d /mnt/html/nginx_config ]; then
  cp /mnt/html/nginx_config/* /mnt/nginx_config
fi

if [ -d /mnt/html/php_config ]; then
  cp /mnt/html/nginx_config/* /mnt/php_config
fi

cd git
#git clone $GIT_REPOSITORY . || exit 1
cd srv || exit 1
for d in $(find . -type d -maxdepth 1 ! -name '.'); do
  d=$(basename $d);
  echo ">>> Setup $d"
  export ROOT=/var/www/html/git/srv/$d/html
  export DOMAIN=$d
  if [ -e $d/nginx.conf ]; then
      cat $d/nginx.conf | envsubst '$ROOT:$DOMAIN' > /mnt/nginx_config/srv_$d.conf
  else
      cat /data/nginx_domain_template.conf| envsubst '$ROOT:$DOMAIN' > /mnt/nginx_config/srv_$d.conf
  fi
done

TIMEOUT=60
echo ">>> Wait for database to startup $TIMEOUT sec"
while [ $(mysqladmin -h $MYSQL_HOST -uroot -p$MYSQL_ROOT_PASSWORD processlist|grep -c event_scheduler) -eq 0 ]; do
    sleep 1
    let TIMEOUT=$TIMEOUT-1
    if [ $TIMEOUT -eq 0 ]; then
        echo "*** Timeout waiting for database"
        exit 1
    fi
done
sleep 1
echo "--- Database is running"

for d in $(find . -type d -maxdepth 1 ! -name '.'); do
  d=$(basename $d);
  MYSQL=$PWD/$d/startup.sql
  if [ -e $MYSQL ]; then
      echo ">>> SQL $d"
    cat $MYSQL | mysql -uroot -p$MYSQL_ROOT_PASSWORD -h$MYSQL_HOST
  fi
  INIT=$PWD/$d/startup_script.sh
  if [ -x $INIT ]; then
      echo ">>> Script $d"
      (
        cd $d
        $INIT
      )
  fi
done