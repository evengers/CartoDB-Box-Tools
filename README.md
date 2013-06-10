#CartoDB Box Tools


CDB Box Tools tries to makeup a stripped down version of CartoDB without the whole Ruby backend. It's composed by Windshaft (the tile server) and CartoDBSQL-API (the sql interface to your database) and a PostGIS database properly configured

You can play with data, visualization and analysis directly on your database without the need of installing a huge system

###Requirements
The setup process will take care of installing everything correctly on the current tested environment Ubuntu 12.04

* node 0.8.x
* mapnik 2.1.1
* postgis 2.1.0


##Installation

	sh ./setup.sh	


###Configure Postgres
	
	sudo nano /etc/postgresql/9.1/main/pg_hba.conf
	# set trust to all connections (TODO unsercure check this)
	# add a connection for a remote connection with: host all all 10.0.2.0/24 trust  

	sudo nano /etc/postgresql/9.1/main/postgresql.conf
	# add line:  listen_addresses='*'


## Usage

To use windshaft you need to:
* setup the config file for a correct postgres connection
* create a database with a postgis template where to store all your tables
* each table with at last the following columns (cartodb_id integer PRIMARY KEY, the_geom geometry, the_geom_webmercator geometry) see:<http://developers.cartodb.com/documentation/analysis.html#basic_geospatial>

Some importers are already created to import and configure correctly your tables.

###Configure PostgreSQL connection

Go to ~/cdb-box-tools/config/environment and check the developments.js configuration. The default configuration can be used if you have a fresh installation of PostGIS

###Create an emtpy database passing a database name
	
	$ ./create_db.sh <DBNAME>


	
###Import a shapefile
The import_shp script import an ESRI shapefile directly to PostGIS and apply all the neccessary configuration and transformation for you. Just specify your database and the .shp file to use.

	
	$ ./import_shp.sh <DBNAME> <SHAPEFILE>
	
	#example
	
	$ ./import_shp.sh usdb ~/shapes/countries/italy.shp
	
	


###Run Windshaft
To run windshaft, that is cloned in swindshaft dir, run the following:

	cd ~/cdb-box-windshaft
	node windshaft-box.js
 
	
	
###Test Windshaft

	open ~/cdb-box-tools/viewer/index.html
	
