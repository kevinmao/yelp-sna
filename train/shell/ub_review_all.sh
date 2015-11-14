#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "Start..."

# input files
review=${YELP_DATA_TSV}/review.tsv
review_train_core=${YELP_DATA_TSV}/review_train_core.tsv
review_test_core=${YELP_DATA_TSV}/review_test_core.tsv
user_keys=${TRAIN_DATA}/user_keys.tsv
business_keys=${TRAIN_DATA}/business_keys.tsv

# output files
ub_review_all_edges=${TRAIN_DATA}/ub_review_all_edges.tsv
ub_review_train_core_edges=${TRAIN_DATA}/ub_review_train_core_edges.tsv
ub_review_test_core_edges=${TRAIN_DATA}/ub_review_test_core_edges.tsv

# process review
LOGGER "Processing ${review}"
rm -f ${ub_review_all_edges}
python ${TRAINING_PYTHON}/user_review_business.py \
--user_keys ${user_keys} \
--business_keys ${business_keys} \
--review ${review} \
--ub_review_edges ${ub_review_all_edges}

# process review_train_core
LOGGER "Processing ${review_train_core}"
rm -f ${ub_review_train_core_edges}
python ${TRAINING_PYTHON}/user_review_business.py \
--user_keys ${user_keys} \
--business_keys ${business_keys} \
--review ${review_train_core} \
--ub_review_edges ${ub_review_train_core_edges}

# process review_test_core
LOGGER "Processing ${review_test_core}"
rm -f ${ub_review_test_core_edges}
python ${TRAINING_PYTHON}/user_review_business.py \
--user_keys ${user_keys} \
--business_keys ${business_keys} \
--review ${review_test_core} \
--ub_review_edges ${ub_review_test_core_edges}

LOGGER "Done."

