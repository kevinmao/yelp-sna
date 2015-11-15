#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."

# all
review_all=${TRAIN_DATA}/ub_review_all_edges.tsv
graph_info=${YELP_DATA_STATS}/graph_info_all.txt
rm -f ${graph_info}

LOGGER "Processing ${review_all}"
python ${STATS_PYTHON}/graph_info.py \
--ub_review_edges ${review_all} \
--graph_info ${graph_info} 

# train
review_train=${TRAIN_DATA}/ub_review_train_edges.tsv
graph_info_train=${YELP_DATA_STATS}/graph_info_train.txt
rm -f ${graph_info_train}

LOGGER "Processing ${review_train}"
python ${STATS_PYTHON}/graph_info.py \
--ub_review_edges ${review_train} \
--graph_info ${graph_info_train} 

# test
review_test=${TRAIN_DATA}/ub_review_test_edges.tsv
graph_info_test=${YELP_DATA_STATS}/graph_info_test.txt
rm -f ${graph_info_test}

LOGGER "Processing ${review_train}"
python ${STATS_PYTHON}/graph_info.py \
--ub_review_edges ${review_test} \
--graph_info ${graph_info_test} 

# train core
review_train_core=${TRAIN_DATA}/ub_review_train_core_edges.tsv
graph_info_train_core=${YELP_DATA_STATS}/graph_info_train_core.txt
rm -f ${graph_info_train_core}

LOGGER "Processing ${review_train_core}"
python ${STATS_PYTHON}/graph_info.py \
--ub_review_edges ${review_train_core} \
--graph_info ${graph_info_train_core} 

# test core
review_test_core=${TRAIN_DATA}/ub_review_test_core_edges.tsv
graph_info_test_core=${YELP_DATA_STATS}/graph_info_test_core.txt
rm -f ${graph_info_test_core}

LOGGER "Processing ${review_train_core}"
python ${STATS_PYTHON}/graph_info.py \
--ub_review_edges ${review_test_core} \
--graph_info ${graph_info_test_core} 

LOGGER "Done."

