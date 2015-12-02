#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${MF_DATA}

mf_model=${MF_DATA}/model

mf_test_data=${MF_DATA}/mf_ub_review_test.tsv
mf_ub_similarity=${MF_DATA}/mf_ub_similarity.tsv

mf_test_data_score=${MF_DATA}/mf_ub_review_test.score
mf_ub_similarity_score=${MF_DATA}/mf_ub_similarity.score

mf_test_data_predicted=${MF_DATA}/mf_ub_review_test.predicted
mf_ub_similarity_predicted=${MF_DATA}/mf_ub_similarity.predicted

# predict
LOGGER "Start..."

LOGGER "Processing ${mf_test_data}"
${LIBMF}/mf-predict ${mf_test_data} ${mf_model} ${mf_test_data_score}

LOGGER "Processing ${mf_ub_similarity}"
${LIBMF}/mf-predict ${mf_ub_similarity} ${mf_model} ${mf_ub_similarity_score}

# combine
paste ${mf_test_data} ${mf_test_data_score} | cut -f1,2,4 > ${mf_test_data_predicted}
paste ${mf_ub_similarity} ${mf_ub_similarity_score} | cut -f1,2,4 > ${mf_ub_similarity_predicted}

LOGGER "Done."
