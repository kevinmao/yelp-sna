#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${PREDICT_DATA}

outge=out.ge
prefix=predict_topn.TP
suffix=tsv
Header=${PREDICT_DATA}/ub_sim_header

MetricsList="common_nbr pref jaccard cosine overlap adamic delta"
mim_com_nbr_list="1 2 5 10 15 20 25 30 35 40 45 50"


for metric in `echo ${MetricsList}`; do
    F=${prefix}.${metric}
    subfolder=${F}
    fou=${PREDICT_DATA}/${F}.${suffix}
    rm -f ${fou}
    printf "%s\t%s\n" "threshold" "tp" > ${fou}
    for mim_com_nbr in `echo $mim_com_nbr_list`; do
        folder=${HDFS_DATA}/${outge}.${mim_com_nbr}
        fin=${folder}/${subfolder}

        # predicted TP
        LOGGER "Processing ${folder}/${subfolder}"
        tp=$(cat ${fin}/part-* | awk '($4==1) {print $0}' | wc -l)
        printf "%d\t%d\n" "${mim_com_nbr}" "${tp}" >> ${fou}
    done
done
LOGGER "Done."
