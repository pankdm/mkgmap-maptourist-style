
INPUT?=		input/example.osm.pbf

STYLE?=		config
TYP?=       M00001e0.TYP
ID?=        480
PAD?=		00000000
MAPID?=		${shell echo ${ID}${PAD} | cut -c1-8}

OSMOSIS?=	bin/osmosis
SPLITTER?=	java -Xmx1500m -jar bin/splitter.jar
MKGMAP?=	java -Xmx1500m -jar bin/mkgmap.jar


NAMELIST?=	name:ru,name,name:en,int_name

all: bounds split convert

bounds:
	mkdir -p boundary
	${OSMOSIS}  \
	--read-pbf file=${INPUT} outPipe.0=1 \
	--buffer inPipe.0=1 outPipe.0=2 \
	--tag-filter reject-relations inPipe.0=2 outPipe.0=3 \
	--tag-filter accept-ways boundary=administrative,postal_code inPipe.0=3 outPipe.0=4 \
	--used-node inPipe.0=4 outPipe.0=5 \
	\
	--read-pbf file=${INPUT} outPipe.0=6 \
	--buffer inPipe.0=6 outPipe.0=7 \
	--tag-filter accept-relations boundary=administrative,postal_code inPipe.0=7 outPipe.0=8 \
	--used-way inPipe.0=8 outPipe.0=9 \
	--used-node inPipe.0=9 outPipe.0=10 \
	\
	--merge inPipe.0=5 inPipe.1=10 outPipe.0=11 \
	--write-pbf file=boundary/local-boundaries.osm.pbf omitmetadata=true compress=deflate inPipe.0=11 

	${MKGMAP} \
	--createboundsfile=boundary/local-boundaries.osm.pbf \
	--bounds=./boundary/local/

split:
	mkdir -p logs
	${SPLITTER} \
		--overlap=0 \
		--max-nodes=1000000 \
		--no-trim \
		--output=pbf \
		--output-dir=splitted \
		--mapid=${MAPID} \
		${INPUT} > logs/splitLocal_log

convert:
	mkdir -p output
	${MKGMAP} \
		--output-dir=output \
		--description="OSM MapTourist" \
		--family-name="OSM MapTourist `date "+%Y-%m-%d"`" \
		--series-name="OSM MapTourist `date "+%Y-%m-%d"`" \
		--overview-mapname="OSM_MapTourist" \
		--area-name="OSM `date "+%Y-%m-%d"`" \
		--family-id=${ID} \
		--keep-going \
		--read-config=optionsfile.args \
		--style-file=./${STYLE} \
		--name-tag-list=${NAMELIST} \
		--housenumbers \
		--gmapsupp \
		-c splitted/template.args ${STYLE}/${TYP}

	# copy typ file for qlandkartegt
	cp ${STYLE}/${TYP} output/${TYP}

clean:
	rm -rf boundary/* splitted/* logs/* output/*
