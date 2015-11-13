#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."

degree_dist_info=${YELP_DATA_STATS}/degree_dist_info.txt
degree_dist_plot=${YELP_DATA_STATS}/degree_dist_plot.pdf
rm -f ${degree_dist_info} ${degree_dist_plot}

python ${DOC_PROCESS_PYTHON}/degree_dist.py \
--ub_review_edges ${TRAIN_DATA}/ub_review_all_edges.tsv \
--degree_dist_info ${degree_dist_info} \
--degree_dist_plot ${degree_dist_plot} 

LOGGER "Done."

