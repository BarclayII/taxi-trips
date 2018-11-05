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

if [[ ! -e $DIR ]]; then
	mkdir -p $DIR
fi

download "$DIR/taxi_zones.zip" https://s3.amazonaws.com/nyc-tlc/misc/taxi_zones.zip
unzip $DIR/taxi_zones.zip -d $DIR
download "$DIR/taxi_zone_lookup.csv" https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv

for (( i=$STARTYEAR; i<=$ENDYEAR; ++i )); do
	if [ $i -eq $STARTYEAR ]; then
		jstart=$STARTMONTH
		jend=12
	elif [ $i -eq $ENDYEAR ]; then
		jstart=01
		jend=$ENDMONTH
	else
		jstart=1
		jend=12
	fi

	for (( j=$jstart; j<=$jend; ++j )); do
		MONTH=`printf %04d-%02d $i $j`
		DEST="$DIR/$MONTH.csv"
		URL="https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_$MONTH.csv"
		download $DEST $URL
	done
done
