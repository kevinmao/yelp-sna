#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "START..."
ub_review_train_edges=${TRAIN_DATA}/ub_review_train_core_edges.tsv
ub_review_test_edges=${TRAIN_DATA}/ub_review_test_core_edges.tsv

mf_train_data=${MF_DATA}/mf_ub_review_train.tsv
mf_test_data=${MF_DATA}/mf_ub_review_test.tsv
mf_meta=${MF_DATA}/meta

rm -f ${mf_train_data} ${mf_test_data} ${mf_meta}

cat ${ub_review_train_edges} | grep -vi 'user_id' > ${mf_train_data}
cat ${ub_review_test_edges} | grep -vi 'user_id' > ${mf_test_data}

m=$(cat ${mf_train_data} | cut -f1 | sort -u | wc -l)
n=$(cat ${mf_train_data} | cut -f2 | sort -u | wc -l)

num_tr=$(cat ${mf_train_data} | wc -l)
num_te=$(cat ${mf_test_data} | wc -l)

fname_tr=$(basename ${mf_train_data})
fname_te=$(basename ${mf_test_data})

printf '%d %d\n' "$m" "$n" > ${mf_meta}
printf '%d %s\n' "${num_tr}" "${fname_tr}" >> ${mf_meta}
printf '%d %s\n' "${num_te}" "${fname_te}" >> ${mf_meta}

LOGGER "Done."

