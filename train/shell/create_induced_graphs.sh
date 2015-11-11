#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${TRAIN_DATA}

suffix=edges.tsv
FolderList="bb_review_all bb_review_test bb_review_train ub_review_all ub_review_test ub_review_train uu_review_all uu_review_test uu_review_train"

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
