#!/bin/bash

mkdir -p tmp

rm -f mkgmap-latest.tar.gz
wget -c http://www.mkgmap.org.uk/snapshots/mkgmap-latest.tar.gz
tar xvfz mkgmap-latest.tar.gz -C tmp

rm -f osmosis-latest.tgz
wget -c http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz
tar xvfz osmosis-latest.tgz -C tmp

rm -f splitter-r200.tar.gz
wget -c http://www.mkgmap.org.uk/splitter/splitter-r200.tar.gz
tar xvfz splitter-r200.tar.gz -C tmp

rm -rf /bin/*.jar
rm -rf /bin/lib
rm -rf lib

cp -rd tmp/mkgmap-*/*.jar bin/
cp -rd tmp/splitter-*/*.jar bin/
cp -rd tmp/splitter-*/lib bin/
cp -rd tmp/osmosis-*/bin/osmosis bin/
cp -rd tmp/osmosis-*/lib .
cp -rd tmp/osmosis-*/config/plexus.conf config/
out=`which zip`
if [ ! -z $out ]; then
    zip -r bin/mkgmap.jar sort
fi

rm -rf tmp
