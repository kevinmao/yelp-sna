#!/bin/bash

# global vars
source ../../config.sh 

OUTDIR=${PREDICT_DATA}/summary
mkdir -p ${OUTDIR}

############################################
### combine TP data
############################################
LOGGER "Processing TP data"
tp=${OUTDIR}/predicted_topn.TP.tsv
mf_tp=${OUTDIR}/mf_predicted_topn.TP.tsv
fout=${OUTDIR}/TP.combined.tsv
ftmp=tmp.`date +%s`

cp ${tp} ${ftmp}.1
cat ${mf_tp} | cut -f7 > ${ftmp}.2
paste ${ftmp}.1 ${ftmp}.2 > ${fout}
rm -f ${ftmp}*

############################################
### combine TP data (augmented)
############################################
LOGGER "Processing TP data (augmented)"
tp=${OUTDIR}/predicted_topn.TP.tsv
mf_tp=${OUTDIR}/mf_predicted_topn.TP.tsv
cand=${OUTDIR}/link_cand_summary.tsv
fout=${OUTDIR}/TP.combined.augmented.tsv
ftmp=tmp.`date +%s`

cp ${tp} ${ftmp}.1
cat ${mf_tp} | cut -f7 > ${ftmp}.2
cat ${cand} | cut -f4 > ${ftmp}.3
paste ${ftmp}.1 ${ftmp}.2 ${ftmp}.3 > ${fout}
rm -f ${ftmp}*

############################################
### combine precision@n data
############################################
LOGGER "Processing precision@n data"
Threshold=${1:-30}

patn=${OUTDIR}/precision.T${Threshold}.tsv
mf_patn=${OUTDIR}/mf_precision.T${Threshold}.tsv
fout=${OUTDIR}/PatN.combined.tsv
ftmp=tmp.`date +%s`

cp ${patn} ${ftmp}.1
cat ${mf_patn} | cut -f7 > ${ftmp}.2
paste ${ftmp}.1 ${ftmp}.2 > ${fout}
rm -f ${ftmp}*

LOGGER "Done."
