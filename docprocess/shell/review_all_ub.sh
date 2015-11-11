#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

prefix=yelp_academic_dataset

# user key file
ftype=review
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${TRAIN_DATA}/review_all_ub_edges.tsv
python ${DOC_PROCESS_PYTHON}/user_review_business.py \
--user_keys ${TRAIN_DATA}/user_keys.tsv \
--business_keys ${TRAIN_DATA}/business_keys.tsv \
--review ${YELP_DATA_TSV}/review.tsv \
--review_all_ub_edges ${TRAIN_DATA}/review_all_ub_edges.tsv 

LOGGER "Done."

