#!/bin/bash

source ../../config.sh

# files
LocalLinkCand=${HDFS_TMP}/ub_similarity.tsv
LocalTestCore=${HDFS_TMP}/ub_review_test_core_edges.tsv

LinkCand=${HDFS_TRAIN_DATA}/ub_similarity.tsv
TestCore=${HDFS_TRAIN_DATA}/ub_review_test_core_edges.tsv

# put onto hdfs
cat ${LocalLinkCand} | grep -v 'user_id' > ${LocalLinkCand}.tmp
cat ${LocalTestCore} | grep -v 'user_id' > ${LocalTestCore}.tmp
N=$(cat $LocalTestCore | grep -v 'user_id' | wc -l)

hadoop fs -mkdir -p ${HDFS_PRJ_HOME}
hadoop fs -rm -r -skipTrash ${LinkCand} ${TestCore} ${PredictedTopN}* ${LinkCand}* >/dev/null 2>&1
hadoop fs -put ${LocalLinkCand}.tmp ${LinkCand}
hadoop fs -put ${LocalTestCore}.tmp ${TestCore}

# run
fpig=top_n_ub.pig
min_com_nbr_list="1 2 5 10 15 20 25 30 35 40 45 50 55 60 65 70"
for min_com_nbr in `echo $min_com_nbr_list`; do
    WDIR=${HDFS_PRJ_HOME}/out.ge.${min_com_nbr}
    hadoop fs -rm -r -skipTrash ${WDIR}
    hadoop fs -mkdir -p ${WDIR}
    LinkCandPruned=${WDIR}/link_cand
    PredictedTopN=${WDIR}/predicted_topn

    pig -useversion 0.11 -f ${TRAINING_PIG}/${fpig} \
    -Dmapred.job.queue.name=gpu \
    -Dmapred.map.tasks.speculative.execution=true \
    -Dmapred.reduce.tasks.speculative.execution=true \
    -Dmapred.job.map.memory.mb=4096 \
    -Dmapred.job.reduce.memory.mb=4096 \
    -param TestCore=$TestCore \
    -param LinkCand=$LinkCand \
    -param LinkCandPruned=$LinkCandPruned \
    -param PredictedTopN=$PredictedTopN \
    -param TOPN=$N \
    -param MIN_COM_NBR=$min_com_nbr
done

# clean up
rm -f ${LocalLinkCand}.tmp ${LocalTestCore}.tmp
