#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# business key file
ftype=business
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/${ftype}_key*.tsv
python ${DOC_PROCESS_PYTHON}/business_keys.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${YELP_DATA_TSV}/${ftype}_keys.tsv 

LOGGER "Done."
