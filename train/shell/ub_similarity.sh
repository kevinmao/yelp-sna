#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "Start..."

# files
review_train_core=${TRAIN_DATA}/ub_review_train_core_edges.tsv
ub_similarity=${TRAIN_DATA}/ub_similarity.tsv

# process review
rm -f ${ub_similarity}
python ${TRAINING_PYTHON}/ub_similarity.py \
--review_train_core ${review_train_core} \
--ub_similarity ${ub_similarity}

LOGGER "Done."

