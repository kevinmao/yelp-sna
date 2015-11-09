#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# user key file
ftype=review
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/{user_user_review_edges,user_business_review_edges,business_business_review_edges}
python ${DOC_PROCESS_PYTHON}/user_review_business.py \
--user_keys ${YELP_DATA_TSV}/user_keys.tsv \
--business_keys ${YELP_DATA_TSV}/business_keys.tsv \
--review ${YELP_DATA_TSV}/review.tsv \
--user_user_review_edges ${YELP_DATA_TSV}/user_user_review_edges.tsv \
--user_business_review_edges ${YELP_DATA_TSV}/user_business_review_edges.tsv \
--business_business_review_edges ${YELP_DATA_TSV}/business_business_review_edges.tsv 

LOGGER "Done."

