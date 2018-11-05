#!/bin/bash

STARTYEAR=$1
STARTMONTH=$2
ENDYEAR=$3
ENDMONTH=$4

DIR=data

if [[ ! -e $DIR ]]; then
	mkdir -p $DIR
fi

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

		if [[ ! -e $DEST ]]; then
			wget -O $DEST $URL
		else
			echo Found $DEST
		fi
	done
done
