#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_STATS}

LOGGER "START..."

review=${TRAIN_DATA}/ub_review_train_core_edges.tsv
user_hist=${YELP_DATA_STATS}/user_hist
business_hist=${YELP_DATA_STATS}/business_hist

review=${TRAIN_DATA}/ub_review_train_core_all_edges.tsv
user_hist=${YELP_DATA_STATS}/user_hist_all
business_hist=${YELP_DATA_STATS}/business_hist_all

review=${TRAIN_DATA}/ub_review_train_maxwcc_edges.tsv
user_hist=${YELP_DATA_STATS}/user_hist_maxwcc
business_hist=${YELP_DATA_STATS}/business_hist_maxwcc

rm -f ${user_hist}* ${business_hist}*

python ${STATS_PYTHON}/histgram.py \
--review ${review} \
--user_hist ${user_hist} \
--business_hist ${business_hist}

LOGGER "Done."