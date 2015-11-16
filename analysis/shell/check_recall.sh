#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_STATS}

LOGGER "START..."

ub_similarity=${TRAIN_DATA}/ub_similarity.tsv
test_core=${TRAIN_DATA}/ub_review_test_core_edges.tsv
stats=${YELP_DATA_STATS}/stats.tsv

{
echo
echo "------------ recall for ub_similarity ------------"
python ${STATS_PYTHON}/check_common_edges.py \
--train_data ${ub_similarity} \
--test_data ${test_core}
} >> ${stats}

LOGGER "Done."

