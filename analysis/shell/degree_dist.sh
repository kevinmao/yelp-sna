#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."

# all
review_all=${TRAIN_DATA}/ub_review_all_edges.tsv
review_train_core=${TRAIN_DATA}/ub_review_train_core_edges.tsv
review_test_core=${TRAIN_DATA}/ub_review_test_core_edges.tsv
digree_dist_plot=${YELP_DATA_STATS}/digree_dist_plot.pdf
rm -f ${digree_dist_plot}

python ${STATS_PYTHON}/degree_dist_plot.py \
--ub_review_edges ${review_all} \
--ub_review_train_core ${review_train_core} \
--ub_review_test_core ${review_test_core} \
--degree_dist_plot ${digree_dist_plot} 

LOGGER "Done."

