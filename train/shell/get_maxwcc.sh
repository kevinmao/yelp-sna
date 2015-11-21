#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

LOGGER "Start..."

# train
review_train=${TRAIN_DATA}/ub_review_train_edges.tsv
review_train_maxwcc=${TRAIN_DATA}/ub_review_train_maxwcc_edges.tsv

rm -f ${review_train_maxwcc}
python ${TRAINING_PYTHON}/getWcc.py \
--review ${review_train} \
--review_maxwcc ${review_train_maxwcc}

# reformat
ftmp=tmp.$(date +%s)
cat ${review_train_maxwcc} | grep -v '^#' > ${ftmp}
printf "%s\t%s\n" "# user_id" "business_id" > ${ftmp}.h
cat ${ftmp}.h ${ftmp} > ${review_train_maxwcc}
rm -f ${ftmp}*

LOGGER "Done."

