#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

Train=${YELP_DATA_TSV}/review_train.tsv
Test=${YELP_DATA_TSV}/review_test.tsv
TrainCore=${YELP_DATA_TSV}/review_train_core_all.tsv
TestCore=${YELP_DATA_TSV}/review_test_core_all.tsv

LOGGER "Start..."
rm -f ${TrainCore} ${TestCore}
python ${TRAINING_PYTHON}/core_review.py \
--review_train ${Train} \
--review_test ${Test} \
--review_train_core ${TrainCore} \
--review_test_core ${TestCore} 
LOGGER "Done."

