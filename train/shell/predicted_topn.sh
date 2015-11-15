#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${PREDICT_DATA}

# user_id business_id gamma_u gamma_b sim_common_nbr sim_pref sim_jaccard sim_cosine sim_overlap sim_adamic sim_delta

suffix=edges.tsv
Header=${PREDICT_DATA}/ub_sim_header

MetricsList="common_nbr pref jaccard cosine overlap adamic delta"

LOGGER "Start..."
let i=4
for m in `echo ${MetricsList}`; do
    LOGGER "Processing $m"
    let i=i+1
    ftmp=tmp.$(date +%s)

    # predicted
    F=predict_topn.$m
    fin=${HDFS_DATA}/$F
    fou=${PREDICT_DATA}/$F
    cat ${fin}/part-* > ${ftmp}.p
    cat ${Header} ${ftmp}.p | cut -f1,2,$i > ${fou}
    
    # predicted TP
    F=predict_topn.TP.$m
    fin=${HDFS_DATA}/$F
    fou=${PREDICT_DATA}/$F
    cat ${fin}/part-* > ${ftmp}.tp
    printf "%s\t%s\t%s" "# user_id" "business_id" "$m" > ${ftmp}.h
    cat ${ftmp}.h ${ftmp}.tp > ${fou}
done
rm -f tmp.*

# remove overlap and cosine for bad performance
rm -f ${PREDICT_DATA}/*{overlap,cosine}*

LOGGER "Done."
