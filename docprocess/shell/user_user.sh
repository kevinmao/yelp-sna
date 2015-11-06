#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset

# user key file
ftype=user
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${YELP_DATA_TSV}/user_user_friend_edges.tsv
python ${DOC_PROCESS}/user_user.py \
--user ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--user_keys ${YELP_DATA_TSV}/${ftype}_keys.tsv \
--user_user_friend_edges ${YELP_DATA_TSV}/user_user_friend_edges.tsv

LOGGER "Done."

