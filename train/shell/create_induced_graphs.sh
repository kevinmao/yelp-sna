#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

suffix=edges.tsv
FolderList="bb_review_test_core bb_review_train_core ub_review_test_core ub_review_train_core uu_review_test_core uu_review_train_core"

LOGGER "Start..."
for d in `echo ${FolderList}`; do
    LOGGER "Processing $d"
    ftmp=tmp.$(date +%s)
    fpath=${HDFS_DATA}/$d
    cat ${fpath}/part-* > ${ftmp}
    sed -e 's/^/# /' ${fpath}/.pig_header > ${ftmp}.header
    cat ${ftmp}.header ${ftmp} > ${TRAIN_DATA}/${d}_${suffix}
    rm -f ${ftmp}*
done
rm -f tmp.*

LOGGER "Done."
