#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

prefix=yelp_academic_dataset

# user key file
ftype=user
LOGGER "Processing ${prefix}_${ftype}.json"
rm -f ${TRAIN_DATA}/${ftype}_key*.tsv
python ${TRAINING_PYTHON}/user_keys.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json \
--output ${TRAIN_DATA}/${ftype}_keys.tsv 

LOGGER "Done."
