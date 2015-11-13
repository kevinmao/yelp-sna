#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

Train=${YELP_DATA_TSV}/review_train.tsv
Test=${YELP_DATA_TSV}/review_test.tsv
PrunedTest=${YELP_DATA_TSV}/review_test_pruned.tsv

# user key file
LOGGER "Start..."
rm -f ${PrunedTest}
python ${TRAINING_PYTHON}/prune_review_test.py \
--review_train ${Train} \
--review_test ${Test} \
--review_test_pruned ${PrunedTest}
LOGGER "Done."

