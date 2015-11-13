#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."

degree_dist_info=${TRAIN_DATA}/degree_dist_info.txt
degree_dist_plot=${TRAIN_DATA}/degree_dist_plot.pdf
wcc_count=${TRAIN_DATA}/wcc_count.txt

rm -f ${degree_dist_info} ${degree_dist_plot} ${wcc_count}
python ${TRAINING_PYTHON}/degree_dist.py \
--ub_review_edges ${TRAIN_DATA}/ub_review_all_edges.tsv \
--degree_dist_info ${degree_dist_info} \
--degree_dist_plot ${degree_dist_plot} \
--wcc_count ${wcc_count} 

LOGGER "Done."

