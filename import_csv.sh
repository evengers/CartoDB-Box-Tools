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
CSVFILE=$2
FILENAME=`basename $CSVFILE`
TABLENAME="${FILENAME%.*}"
LON=$4
LAT=$5


echo "Importing CSV to $TABLENAME"

sed "s/##FILENAME##/$TABLENAME/g" template_vrt.vrt > $TABLENAME.vrt
sed -i "s/##DATASOURCE##/$FILENAME/g" $TABLENAME.vrt
sed -i "s/##LON##/$LON/g" $TABLENAME.vrt
sed -i "s/##LAT##/$LAT/g" $TABLENAME.vrt



#Importing csv
ogr2ogr -f PostgreSQL PG:"user=$PGUSER dbname=$DBNAME" -lco GEOMETRY_NAME=the_geom -lco FID=cartodb_id -overwrite $TABLENAME.vrt

#rm $TABLENAME.vrt;

#Configuring imported table for windshaft use
psql -d$DBNAME -c "ALTER TABLE $TABLENAME ADD the_geom_webmercator geometry"
psql -d$DBNAME -c "UPDATE $TABLENAME SET the_geom_webmercator = ST_Transform(the_geom, 3857)"
 
