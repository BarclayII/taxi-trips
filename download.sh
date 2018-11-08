#!/bin/bash

STARTYEAR=$1
STARTMONTH=$2
ENDYEAR=$3
ENDMONTH=$4

DIR=data

download () {
	DEST=$1
	URL=$2
	if [[ ! -e $DEST ]]; then
		wget -O $DEST $URL
	else
		echo Found $DEST
	fi
}

download_and_unzip () {
	DEST=$1
	URL=$2
	if [[ ! -e $DEST ]]; then
		wget -O $DEST $URL
		unzip $DEST -d $DIR
	else
		echo Found $DEST
	fi
}

if [[ ! -e $DIR ]]; then
	mkdir -p $DIR
fi

download_and_unzip "$DIR/taxi_zones.zip" https://s3.amazonaws.com/nyc-tlc/misc/taxi_zones.zip
download_and_unzip "$DIR/nyc_street_maps.zip" "https://data.cityofnewyork.us/api/geospatial/exjm-f27b?method=export&format=Shapefile"
mv $DIR/geo_export*.dbf $DIR/geo_export.dbf
mv $DIR/geo_export*.prj $DIR/geo_export.prj
mv $DIR/geo_export*.shp $DIR/geo_export.shp
mv $DIR/geo_export*.shx $DIR/geo_export.shx
download "$DIR/Centerline.pdf" "https://data.cityofnewyork.us/api/views/exjm-f27b/files/cba8af99-6cd5-49fd-9019-b4a6c2d9dff7?download=true&filename=Centerline.pdf"
download "$DIR/taxi_zone_lookup.csv" https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv

for (( i=$STARTYEAR; i<=$ENDYEAR; ++i )); do
	if [ $i -eq $STARTYEAR ]; then
		jstart=$STARTMONTH
	else
		jstart=1
	fi

	if [ $i -eq $ENDYEAR ]; then
		jend=$ENDMONTH
	else
		jend=12
	fi

	for (( j=$jstart; j<=$jend; ++j )); do
		MONTH=`printf %04d-%02d $i $j`
		DEST="$DIR/$MONTH.csv"
		URL="https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_$MONTH.csv"
		download $DEST $URL
	done
done
