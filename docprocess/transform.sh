#!/bin/bash

# global vars
source ../config.sh 
rm -fr ${YELP_DATA_TSV}
mkdir -p ${YELP_DATA_TSV}

# tip file
fname=yelp_academic_dataset_tip
LOGGER "Processing ${fname}.json"
python tip.py \
--input ${YELP_DATA_JSON}/${fname}.json \
--output ${YELP_DATA_TSV}/${fname}.tsv

LOGGER "Done."
