#!/bin/bash

source ../../config.sh

# files
LocalPredicted=${HDFS_TMP}/for_mf_test.predict
LocalTestCore=${HDFS_TMP}/ub_review_test_core_edges.tsv

Predicted=${HDFS_TRAIN_DATA}/for_mf_test.predict
TestCore=${HDFS_TRAIN_DATA}/ub_review_test_core_edges.tsv
WDIR=${HDFS_PRJ_HOME}/out2
TopPredicted=${WDIR}/predict_topn
TruePositive=${WDIR}/predict_topn.TP

# put onto hdfs
cat ${LocalPredicted} | grep -v 'user_id' > ${LocalPredicted}.tmp
cat ${LocalTestCore} | grep -v 'user_id' > ${LocalTestCore}.tmp
N=$(cat $LocalTestCore | grep -v 'user_id' | wc -l)

hadoop fs -mkdir -p ${HDFS_PRJ_HOME}
hadoop fs -rm -r -skipTrash ${TruePositive}* ${TopPredicted}* >/dev/null 2>&1
hadoop fs -put ${LocalPredicted}.tmp ${Predicted}
hadoop fs -put ${LocalTestCore}.tmp ${TestCore}

# run
fpig=top_n_mf.pig

pig -useversion 0.11 -f ${TRAINING_PIG}/${fpig} \
-Dmapred.job.queue.name=gpu \
-Dmapred.map.tasks.speculative.execution=true \
-Dmapred.reduce.tasks.speculative.execution=true \
-Dmapred.job.map.memory.mb=4096 \
-Dmapred.job.reduce.memory.mb=4096 \
-param Predicted=$Predicted \
-param TestCore=$TestCore \
-param TopPredicted=$TopPredicted \
-param TruePositive=$TruePositive \
-param N=$N

# clean up
rm -f ${LocalPredicted}.tmp ${LocalTestCore}.tmp