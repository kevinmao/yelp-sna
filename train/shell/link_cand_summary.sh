#!/bin/bash

# global vars
source ../../config.sh 

OUTDIR=${PREDICT_DATA}/summary
mkdir -p ${OUTDIR}

outge=out.ge
[[ -n "$1" ]] && outge=$1.out.ge

fsum=${OUTDIR}/link_cand_summary.tsv
[[ -n "$1" ]] && fsum=${OUTDIR}/$1_link_cand_summary.tsv

# combine summary data
rm -f ${fsum}
Header=${HDFS_DATA}/${outge}.1/link_cand.summary/.pig_header
cp ${Header} ${fsum}

fin=${HDFS_DATA}/${outge}*/link_cand.summary
cat ${fin}/part* | sort -k1 -n >> ${fsum}

LOGGER "Done."
