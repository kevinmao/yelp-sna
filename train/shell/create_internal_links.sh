#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."
output=${TRAIN_DATA}/ub_internal_links.tsv
rm -f ${output}
python ${TRAINING_PYTHON}/ub_internal_links.py \
--ub_review_test_edges ${TRAIN_DATA}/ub_review_test_edges.tsv \
--ub_internal_link_candidates ${TRAIN_DATA}/ub_internal_link_candidates.tsv \
--ub_internal_links ${output}

LOGGER "Done."

