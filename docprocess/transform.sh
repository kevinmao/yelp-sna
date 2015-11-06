#!/bin/bash

# global vars
source ../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# tip file
ftype=tip
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}.tsv
python tip.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}.tsv

# review file
ftype=review
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}.tsv
python review.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}.tsv

# user file
ftype=user
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}.tsv
python user.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}.tsv

# business file
ftype=business
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}.tsv
python business.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}.tsv

# checkin file
ftype=checkin
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}.tsv
python checkin.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}.tsv

LOGGER "Done."

