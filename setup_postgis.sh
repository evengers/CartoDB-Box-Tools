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




POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-2.1

createdb -E UTF8 template_postgis

createlang -d template_postgis plpgsql

psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis'"
psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
psql -d template_postgis -f $POSTGIS_SQL_PATH/legacy.sql
psql -d template_postgis -f $POSTGIS_SQL_PATH/rtpostgis.sql
psql -d template_postgis -f $POSTGIS_SQL_PATH/topology.sql
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
