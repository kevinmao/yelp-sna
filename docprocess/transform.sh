#!/bin/bash

# global vars
source ../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

#: << 'EOM'
# tip file
ftype=tip
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${prefix}_${ftype}.tsv
python tip.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${prefix}_${ftype}.tsv
#EOM

# review file
ftype=review
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${prefix}_${ftype}.tsv
python review.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${prefix}_${ftype}.tsv


LOGGER "Done."
