#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."

review_all=${TRAIN_DATA}/ub_review_all_edges.tsv
degree_dist_info=${YELP_DATA_STATS}/degree_dist_info.txt
degree_dist_plot=${YELP_DATA_STATS}/degree_dist_plot.pdf

review_core=${TRAIN_DATA}/ub_review_train_core_edges.tsv
degree_dist_traincore_info=${YELP_DATA_STATS}/degree_dist_traincore_info.txt
degree_dist_traincore_plot=${YELP_DATA_STATS}/degree_dist_traincore_plot.pdf

LOGGER "Processing ${review_all}"
rm -f ${degree_dist_info} ${degree_dist_plot}
python ${STATS_PYTHON}/degree_dist.py \
--ub_review_edges ${review_all} \
--degree_dist_info ${degree_dist_info} \
--degree_dist_plot ${degree_dist_plot} 

LOGGER "Processing ${review_core}"
rm -f ${degree_dist_traincore_info} ${degree_dist_traincore_plot}
python ${STATS_PYTHON}/degree_dist.py \
--ub_review_edges ${review_core} \
--degree_dist_info ${degree_dist_traincore_info} \
--degree_dist_plot ${degree_dist_traincore_plot} 

LOGGER "Done."

