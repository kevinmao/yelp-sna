#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

Train=${TRAIN_DATA}/ub_review_train_edges.tsv
Test=${TRAIN_DATA}/ub_review_test_edges.tsv
TrainMaxWcc=${TRAIN_DATA}/ub_review_train_maxwcc_edges.tsv
TrainCore=${TRAIN_DATA}/ub_review_train_core_all_edges.tsv
TestCore=${TRAIN_DATA}/ub_review_test_core_all_edges.tsv

LOGGER "Start..."
rm -f ${TrainCore} ${TestCore}
python ${TRAINING_PYTHON}/core_review.py \
--review_train ${Train} \
--review_test ${Test} \
--review_train_maxwcc ${TrainMaxWcc} \
--review_train_core ${TrainCore} \
--review_test_core ${TestCore} 
LOGGER "Done."

