#!/bin/sh
DEVENV=./config/environments/development

echo '#################\nStripped CartoDB Tools\n#################';

# Extract postgres configuration

PGUSER=`node -e "console.log(require('${DEVENV}').postgres.user)"`
echo "PGUSER: [$PGUSER]"
PGHOST=`node -e "console.log(require('${DEVENV}').postgres.host)"`
echo "PGHOST: [$PGHOST]"
PGPORT=`node -e "console.log(require('${DEVENV}').postgres.port)"`
echo "PGPORT: [$PGPORT]"
PGPASSWORD=`node -e "console.log(require('${DEVENV}').postgres.password)"`

export PGUSER PGHOST PGPORT PGPASSWORD

die() {
        msg=$1
        echo "${msg}" >&2
        exit 1
}

DBNAME=$1

dropdb $DBNAME | 2>&1
createdb -Ttemplate_postgis -EUTF8 $DBNAME || die "Could not create test database" 


FILES=./sql/cdb/*
for f in $FILES
do
  echo 'processing '$f
  psql -d $DBNAME < $f
done
