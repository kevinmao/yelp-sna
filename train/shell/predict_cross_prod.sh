#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "Start..."

lbl=${1:-rating}
mf_model=${MF_DATA}/model
mf_test_data=${MF_DATA}/ub_cross_prod.tsv
mf_predicted_result=${MF_DATA}/predicted_ub_cross_prod.${lbl}

${LIBMF}/mf-predict ${mf_test_data} ${mf_model} ${mf_predicted_result}

LOGGER "Done."

