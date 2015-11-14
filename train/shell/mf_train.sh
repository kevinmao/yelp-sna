#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

lbl=${1:-rating}

mf_train_data=${MF_DATA}/mf_ub_review_train.tsv
mf_test_data=${MF_DATA}/mf_ub_review_test.tsv
mf_model=${MF_DATA}/model
mf_predicted_result=${MF_DATA}/predicted_result
mf_log=${MF_DATA}/mf.log

{
LOGGER "Start..."

: << 'EOM'
for t in {5,10,15,20,25,30}; do
LOGGER "Training [factor = $t]"
${LIBMF}/mf-train -k $t ${mf_train_data} ${mf_model}.$t
${LIBMF}/mf-predict ${mf_test_data} ${mf_model}.$t ${mf_predicted_result}.$t
done
EOM

${LIBMF}/mf-train ${mf_train_data} ${mf_model}
${LIBMF}/mf-predict ${mf_test_data} ${mf_model} ${mf_predicted_result}

LOGGER "Done."

} > ${mf_log}
