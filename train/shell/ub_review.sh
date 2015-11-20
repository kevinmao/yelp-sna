#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "Start..."

# input files
review=${YELP_DATA_TSV}/review.tsv
review_train=${YELP_DATA_TSV}/review_train.tsv
review_test=${YELP_DATA_TSV}/review_test.tsv
user_keys=${TRAIN_DATA}/user_keys.tsv
business_keys=${TRAIN_DATA}/business_keys.tsv

# output files
ub_review_all_edges=${TRAIN_DATA}/ub_review_all_edges.tsv
ub_review_train_edges=${TRAIN_DATA}/ub_review_train_edges.tsv
ub_review_test_edges=${TRAIN_DATA}/ub_review_test_edges.tsv

# process review
LOGGER "Processing ${review}"
rm -f ${ub_review_all_edges}
python ${TRAINING_PYTHON}/user_review_business.py \
--user_keys ${user_keys} \
--business_keys ${business_keys} \
--review ${review} \
--ub_review_edges ${ub_review_all_edges}

# process review_train
LOGGER "Processing ${review_train}"
rm -f ${ub_review_train_edges}
python ${TRAINING_PYTHON}/user_review_business.py \
--user_keys ${user_keys} \
--business_keys ${business_keys} \
--review ${review_train} \
--ub_review_edges ${ub_review_train_edges}

# process review_test
LOGGER "Processing ${review_test}"
rm -f ${ub_review_test_edges}
python ${TRAINING_PYTHON}/user_review_business.py \
--user_keys ${user_keys} \
--business_keys ${business_keys} \
--review ${review_test} \
--ub_review_edges ${ub_review_test_edges}

LOGGER "Done."

