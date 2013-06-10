DEVENV=./config/environments/development

# Extract postgres configuration

PGUSER=`node -e "console.log(require('${DEVENV}').postgres.user)"`
echo "PGUSER: [$PGUSER]"
PGHOST=`node -e "console.log(require('${DEVENV}').postgres.host)"`
echo "PGHOST: [$PGHOST]"
PGPORT=`node -e "console.log(require('${DEVENV}').postgres.port)"`
echo "PGPORT: [$PGPORT]"
PGPASSWORD=`node -e "console.log(require('${DEVENV}').postgres.password)"`

export PGUSER PGHOST PGPORT PGPASSWORD


DBNAME=$1
SHAPEFILE=$2
FILENAME=`basename $SHAPEFILE`
TABLENAME="${FILENAME%.*}"

echo "Importing Shapefile to $TABLENAME"

#Importing shape
ogr2ogr -t_srs EPSG:4326 -f PostgreSQL PG:"user=$PGUSER dbname=$DBNAME" $SHAPEFILE -lco GEOMETRY_NAME=the_geom -lco FID=cartodb_id -overwrite

#Configuring imported table for windshaft use
psql -d$DBNAME -c "ALTER TABLE $TABLENAME ADD the_geom_webmercator geometry"
psql -d$DBNAME -c "UPDATE $TABLENAME SET the_geom_webmercator = ST_Transform(the_geom, 3857)"
