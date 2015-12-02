#!/bin/bash

# global vars
source ../../config.sh 

OUTDIR=${PREDICT_DATA}/topn
mkdir -p ${OUTDIR}

outge=out.ge
prefix=predicted_topn
suffix=tsv

MetricsList="common_nbr pref jaccard cosine overlap adamic delta random"
min_com_nbr_list="1 2 5 10 15 20 25 30 35 40 45 50 55 60 65 70"

for metric in `echo ${MetricsList}`; do
    F=${prefix}.${metric}
    subfolder=${prefix}.${metric}
    for min_com_nbr in `echo $min_com_nbr_list`; do
        folder=${HDFS_DATA}/${outge}.${min_com_nbr}
        fin=${folder}/${subfolder}
        Header=${fin}/.pig_header

        fou=${OUTDIR}/${F}.T${min_com_nbr}.${suffix}
        if [ -d $folder ]; then
            LOGGER "Processing ${fin}"
            rm -f ${fou}
            cp ${Header} ${fou}
            cat ${fin}/part-* >> ${fou}
        fi    
    done
done

LOGGER "Done."
