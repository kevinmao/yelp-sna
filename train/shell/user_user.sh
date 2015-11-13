#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

prefix=yelp_academic_dataset

# user key file
ftype=user
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${TRAIN_DATA}/user_friend_edges.tsv
python ${TRAINING_PYTHON}/user_user.py \
--user ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--user_keys ${TRAIN_DATA}/${ftype}_keys.tsv \
--user_friend_edges ${TRAIN_DATA}/user_friend_edges.tsv

LOGGER "Done."

