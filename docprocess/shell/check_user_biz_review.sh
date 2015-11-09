#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# user file
python ${DOC_PROCESS_PYTHON}/check_user_biz_review.py \
--user_keys ${YELP_DATA_TSV}/user_keys.tsv \
--business_keys ${YELP_DATA_TSV}/business_keys.tsv \
--review ${YELP_DATA_TSV}/review.tsv \
--output ${YELP_DATA_TSV}/stats.tsv 

LOGGER "Done."
