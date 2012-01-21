#!/bin/bash

mkdir -p tmp
mkgmap_url='http://www.mkgmap.org.uk/snapshots/mkgmap-latest.tar.gz'
splitter_url='http://www.mkgmap.org.uk/splitter/splitter-r200.tar.gz'
osmosis_url='http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz'
mkgmap=`basename $mkgmap_url`
splitter=`basename $splitter_url`
osmosis=`basename $osmosis_url`

remote_size=`wget --spider --server-response $mkgmap_url -O - 2>&1 | sed -ne '/Content-Length/{s/.*: //;p}'`
local_size=`ls -l $mkgmap | awk '{ print $5 }'`
if [ ${remote_size}x != ${local_size}x ]; then
	rm -f $mkgmap
	wget -c $mkgmap_url
fi
tar xfz $mkgmap -C tmp

remote_size=`wget --spider --server-response $osmosis_url -O - 2>&1 | sed -ne '/Content-Length/{s/.*: //;p}'`
local_size=`ls -l $osmosis | awk '{ print $5 }'`
if [ ${remote_size}x != ${local_size}x ]; then
	rm -f $osmosis
	wget -c $osmosis_url
fi
tar xfz $osmosis -C tmp

remote_size=`wget --spider --server-response $splitter_url -O - 2>&1 | sed -ne '/Content-Length/{s/.*: //;p}'`
local_size=`ls -l $splitter | awk '{ print $5 }'`
if [ ${remote_size}x != ${local_size}x ]; then
	rm -f $splitter
	wget -c $splitter_url
fi
tar xfz $splitter -C tmp

mkdir -p contrib

rm -rf contrib/*-latest

cp -rd tmp/mkgmap-* contrib/mkgmap-latest
cp -rd tmp/splitter-* contrib/splitter-latest
cp -rd tmp/osmosis-* contrib/osmosis-latest

ln -sf ../contrib/mkgmap-latest/mkgmap.jar bin/mkgmap.jar
ln -sf ../contrib/splitter-latest/splitter.jar bin/splitter.jar
ln -sf ../contrib/osmosis-latest/bin/osmosis bin/osmosis

rm -rf tmp
