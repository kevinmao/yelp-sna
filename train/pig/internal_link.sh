#!/bin/bash

source ../../config.sh

UserUserTrain=${HDFS_TRAIN_DATA}/uu_review_train_edges.tsv
BizBizTrain=${HDFS_TRAIN_DATA}/bb_review_train_edges.tsv
UserBizTrain=${HDFS_TRAIN_DATA}/ub_review_train_edges.tsv
WDIR=${HDFS_PRJ_HOME}/out
PigFilesS="ub_internal_link_candidates.pig bu_internal_link_candidates.pig"

# run
for fpig in `echo $PigFilesS`; do
G=$(basename $fpig | sed 's/_candidates.pig//g')
out=${WDIR}/${G}
hadoop fs -rm -r -skipTrash ${out} >/dev/null 2>&1
pig -useversion 0.11 -f ${TRAINING_PIG}/${fpig} \
-Dmapred.job.queue.name=gpu \
-Dmapred.map.tasks.speculative.execution=true \
-Dmapred.reduce.tasks.speculative.execution=true \
-Dmapred.job.map.memory.mb=3076 \
-Dmapred.job.reduce.memory.mb=3076 \
-param UserUserTrain=$UserUserTrain \
-param BizBizTrain=$BizBizTrain \
-param UserBizTrain=$UserBizTrain \
-param UserUserTrain2=uu_review_train_edges.tsv \
-param BizBizTrain2=bb_review_train_edges.tsv \
-param UserBizTrain2=ub_review_train_edges.tsv \
-param Output=$out
done

