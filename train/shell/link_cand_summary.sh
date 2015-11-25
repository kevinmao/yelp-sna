#!/bin/bash

# global vars
source ../../config.sh 

OUTDIR=${PREDICT_DATA}/summary
mkdir -p ${OUTDIR}

TestCore=${TRAIN_DATA}/ub_review_test_core_edges.tsv
CHECK_COMMON="python ${STATS_PYTHON}/check_common_edges.py"

outge=out.ge
fcov=${OUTDIR}/link_cand_coverage.tsv
fsum=${OUTDIR}/link_cand_summary.tsv

MetricsList="common_nbr pref jaccard cosine overlap adamic delta"
min_com_nbr_list="1 2 5 10 15 20 25 30 35 40 45 50 55 60 65 70"

LOGGER "Start..."

# coverage
rm -f ${fcov}
printf "%s\t%s\n" "threshold" "coverage" > ${fcov}
for min_com_nbr in `echo $min_com_nbr_list`; do
    ftmp=tmp.`date +%s`
    fin=${HDFS_DATA}/${outge}.${min_com_nbr}/link_cand
    if [ -d $folder ]; then
        LOGGER "Processing ${fin}"
        cat ${fin}/part-r* > ${ftmp}
        N=$(${CHECK_COMMON} --train_data ${ftmp} --test_data ${TestCore} --simple 1)
        printf "%d\t%d\n" "${min_com_nbr}" "${N}" >> ${fcov}
    fi
    rm -f ${ftmp}
done

# combine summary data
rm -f ${fsum}
Header=${HDFS_DATA}/${outge}.1/link_cand.summary/.pig_header
cp ${Header} ${fsum}
for min_com_nbr in `echo $min_com_nbr_list`; do
    fin=${HDFS_DATA}/${outge}.${min_com_nbr}/link_cand.summary
    if [ -d $folder ]; then
        LOGGER "Processing ${fin}"
        cat ${fin}/part-r* >> ${fsum}
    fi
done

# combine all
ftmp=tmp.`date +%s`
cat ${fcov} | cut -f2 > ${ftmp}.1
paste ${fsum} ${ftmp}.1 > ${ftmp}.2
mv ${ftmp}.2 ${fsum}

rm -f ${ftmp}*

LOGGER "Done."
