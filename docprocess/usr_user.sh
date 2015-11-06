#!/bin/bash

# global vars
source ../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# user key file
ftype=user
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}_key*.tsv
python user_user.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}_key.tsv \
--output_user_user ${YELP_DATA_TSV}/${ftype}_user_edges.tsv 

LOGGER "Done."
