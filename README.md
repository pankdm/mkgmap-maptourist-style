This is a project to provide easy and convenient way to convert Garmin 
maps from OpenStreetMap data using mkgmap and style files from 
<http://maptourist.org>.

## Description

List of supported poi can be found [here](features/).

## Usage

**1.** Download the latest versions of `mkgmap`, `splitter`, `osmosis`:

```
./update_bin.sh
```

**2.** Download the map (that you want to convert) in `pbf` format. Possible links:
  - Worldwide: <http://download.geofabrik.de/openstreetmap/>
  - Russia and xUSSR: <http://gis-lab.info/projects/osm_dump/>

More links: <http://wiki.openstreetmap.org/wiki/Planet.osm>


**3.** Generate map:

```
make split convert INPUT=/path/to/pbf/file
```

The file `output/gmapsupp.img` is ready to be uploaded to device
