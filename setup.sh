#!/bin/sh
sudo apt-get install python-software-properties
sudo dpkg --purge postgis postgresql-9.1-postgis
sudo apt-add-repository -y ppa:sharpie/for-science
sudo apt-add-repository -y ppa:sharpie/postgis-nightly
sudo add-apt-repository -y ppa:mapnik/v2.1.0
sudo add-apt-repository -y ppa:mapnik/boost
sudo apt-get update
sudo apt-get install -y git build-essential postgresql-9.1-postgis postgresql-server-dev-9.1 libmapnik libmapnik-dev mapnik-utils python-mapnik libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-python-dev libboost-regex-dev libboost-system-dev libboost-thread-dev redis-server imagemagick gdal-bin


#follow these instructions instead to configure nose with npm
#https://www.digitalocean.com/community/articles/how-to-install-an-upstream-version-of-node-js-on-ubuntu-12-04
#installing node
#cd  ~
#mkdir src
# cd src
#wget http://nodejs.org/dist/v0.8.9/node-v0.8.9.tar.gz
#tar xzfv node-v0.8.9.tar.gz
#cd node-v0.8.9
#./configure
#make
#sudo make install


#configuring postgis
cd ~/stripped-cdb
sudo -u postgres sh setup_postgis.sh

cd ~
git clone https://github.com/markov00/CartoDB-Box-Tools.git cdb-box-tools

