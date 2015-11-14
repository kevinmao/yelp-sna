#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "Start..."

# files
ub_review_train_core_edges=${TRAIN_DATA}/ub_review_train_core_edges.tsv
ub_cross_prod=${MF_DATA}/ub_cross_prod.tsv

# process review
rm -f ${ub_review_cross_prod_edges}
python ${TRAINING_PYTHON}/ub_cross_prod.py \
--review_train_core ${ub_review_train_core_edges} \
--ub_cross_prod ${ub_cross_prod}

LOGGER "Done."
