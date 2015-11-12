#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."
: << 'EOM'
LOGGER "Create user-business internal links"
output=${TRAIN_DATA}/ub_internal_link_candidates.tsv
rm -f ${output}
python ${TRAINING_PYTHON}/ub_internal_link_cand.py \
--ub_review_train_edges ${TRAIN_DATA}/ub_review_train_edges.tsv \
--uu_review_train_edges ${TRAIN_DATA}/uu_review_train_edges.tsv \
--internal_link_candidates ${output}
EOM

LOGGER "Create business-user internal links"
output=${TRAIN_DATA}/bu_internal_link_candidates.tsv
rm -f ${output}
python ${TRAINING_PYTHON}/bu_internal_link_cand.py \
--ub_review_train_edges ${TRAIN_DATA}/ub_review_train_edges.tsv \
--bb_review_train_edges ${TRAIN_DATA}/bb_review_train_edges.tsv \
--internal_link_candidates ${output}

LOGGER "Done."

