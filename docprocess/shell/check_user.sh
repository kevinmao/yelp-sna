#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# user file
ftype=user
LOGGER "Processing ${prefix}_${ftype}.json"
python ${DOC_PROCESS}/check_user.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json

LOGGER "Done."
