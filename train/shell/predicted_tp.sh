#!/bin/bash

# global vars
source ../../config.sh 

OUTDIR=${PREDICT_DATA}/summary
mkdir -p ${OUTDIR}

outge=out.ge
prefix=predicted_topn
suffix=tsv

MetricsList="common_nbr pref jaccard cosine overlap adamic delta random"
min_com_nbr_list="1 2 5 10 15 20 25 30 35 40 45 50 55 60 65 70"

# each metrics
for metric in `echo ${MetricsList}`; do
    F=${prefix}.${metric}
    subfolder=${F}
    fou=${OUTDIR}/${F}.${suffix}
    rm -f ${fou}
    lbl=tp_${metric}
    printf "%s\t%s\n" "threshold" "${lbl}" > ${fou}
    for min_com_nbr in `echo $min_com_nbr_list`; do
        folder=${HDFS_DATA}/${outge}.${min_com_nbr}
        fin=${folder}/${subfolder}
        if [ -d $folder ]; then
            # predicted TP
            LOGGER "Processing ${folder}/${subfolder}"
            tp=$(cat ${fin}/part-* | awk '($4==1) {print $0}' | wc -l)
            printf "%d\t%d\n" "${min_com_nbr}" "${tp}" >> ${fou}
        fi    
    done
done

# combine
fout=${OUTDIR}/${prefix}.TP.${suffix}
mv ${OUTDIR}/${prefix}.common_nbr.${suffix} ${fout}
for metric in `echo ${MetricsList}`; do
    if [ "$metric" == "common_nbr" ]; then
        continue
    fi    
    ftmp=tmp.`date +%s`
    F=${OUTDIR}/${prefix}.${metric}.${suffix}
    cat $F | cut -f2 > ${ftmp}.1
    paste ${fout} ${ftmp}.1 > ${ftmp}.2
    mv ${ftmp}.2 ${fout}
    rm -f $F ${ftmp}*
done


LOGGER "Done."
