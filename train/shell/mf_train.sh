#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${MF_DATA}

mf_train_data=${MF_DATA}/mf_ub_review_train.tsv
mf_test_data=${MF_DATA}/mf_ub_review_test.tsv
mf_model=${MF_DATA}/model
mf_predicted_result=${MF_DATA}/predicted_result
mf_log=${MF_DATA}/mf.log

{
LOGGER "Start..."

: << 'EOM'
for k in {10,20,30,40,50,60,70,80,90,100}; do
LOGGER "Training [factor = $k]"
${LIBMF}/mf-train -l 0.05 -k $k --nmf ${mf_train_data} ${mf_model}.$k
${LIBMF}/mf-predict ${mf_test_data} ${mf_model}.$k ${mf_predicted_result}.$k
echo
done
EOM

${LIBMF}/mf-train -k 100 --nmf ${mf_train_data} ${mf_model}

} > ${mf_log}
LOGGER "Done."
