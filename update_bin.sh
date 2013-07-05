#!/bin/bash

set -e

mkgmap_url='http://www.mkgmap.org.uk/download/mkgmap-latest.tar.gz'
splitter_url='http://www.mkgmap.org.uk/download/splitter-latest.tar.gz'
osmosis_url='http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz'

update_dist() {
	dist_url=$1
	tmp_suffix=$2
	dist_file=`basename $dist_url`
	remote_size=`wget --spider --server-response $dist_url -O - 2>&1 | sed -ne '/Content-Length/{s/.*: //;p}'`
	if [ -e $dist_file ]; then
		local_size=`ls -l $dist_file | awk '{ print $5 }'`
	else
		local_size=0
	fi
	if [ ${remote_size}x != ${local_size}x ]; then
		rm -f $dist_file
		wget -c $dist_url
	fi
	mkdir -p tmp/${tmp_suffix}
	tar xfz $dist_file -C tmp/${tmp_suffix}
}

mkdir -p tmp

update_dist ${mkgmap_url}
update_dist ${splitter_url}
update_dist ${osmosis_url} osmosis-latest

mkdir -p contrib

rm -rf contrib/*-latest

cp -rd tmp/mkgmap-* contrib/mkgmap-latest
cp -rd tmp/splitter-* contrib/splitter-latest
cp -rd tmp/osmosis-* contrib/osmosis-latest

ln -sf ../contrib/mkgmap-latest/mkgmap.jar bin/mkgmap.jar
ln -sf ../contrib/splitter-latest/splitter.jar bin/splitter.jar
ln -sf ../contrib/osmosis-latest/bin/osmosis bin/osmosis

rm -rf tmp
