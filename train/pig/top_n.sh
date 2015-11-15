#!/bin/bash

source ../../config.sh

# files
LocalPredicted=${HDFS_TMP}/ub_similarity.tsv
LocalTestCore=${HDFS_TMP}/ub_review_test_core_edges.tsv

Predicted=${HDFS_TRAIN_DATA}/ub_similarity.tsv
TestCore=${HDFS_TRAIN_DATA}/ub_review_test_core_edges.tsv
WDIR=${HDFS_PRJ_HOME}/out
TopPredicted=${WDIR}/predict_topn
TruePositive=${WDIR}/predict_topn.TP

# upload
cat ${LocalPredicted} | grep -v 'user_id' > ${LocalPredicted}.tmp
cat ${LocalTestCore} | grep -v 'user_id' > ${LocalTestCore}.tmp
N=$(cat $LocalTestCore | grep -v 'user_id' | wc -l)

hadoop fs -rm -r -skipTrash ${TruePositive}* ${TopPredicted}*
hadoop fs -put ${LocalPredicted}.tmp ${Predicted}
hadoop fs -put ${LocalTestCore}.tmp ${TestCore}

# run
fpig=top_n_ub.pig

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