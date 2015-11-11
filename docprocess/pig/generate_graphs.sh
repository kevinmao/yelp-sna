#!/bin/bash

source ../../config.sh

# put onto hdfs
hadoop fs -rm -r skipTrash ${HDFS_PRJ_HOME} >/dev/null 2>&1
hadoop fs -put ~/${PRJ_NAME} ${HDFS_PRJ_HOME}

UserKeys=${HDFS_TRAIN_DATA}/user_keys.tsv
BusinessKeys=${HDFS_TRAIN_DATA}/business_keys.tsv
ReviewFiles="review_test.tsv review_train.tsv"
WDIR=${HDFS_PRJ_HOME}/out
PigFilesS="ub_review_graph.pig bb_review_graph.pig uu_review_graph.pig"

# run
for fname in `echo ${ReviewFiles}`; do
Review=${HDFS_YELP_DATA_TSV}/${fname}
F=$(echo $fname | sed 's/.tsv//g')
for fpig in `echo $PigFilesS`; do
G=$(basename $fpig | sed 's/_review_graph.pig//g')
out=${WDIR}/${F}_${G}
hadoop fs -rm -r -skipTrash ${out} >/dev/null 2>&1
pig -useversion 0.11 -f ${DOC_PROCESS_PIG}/${fpig} \
-Dmapred.job.queue.name=gpu \
-Dmapred.map.tasks.speculative.execution=true \
-Dmapred.reduce.tasks.speculative.execution=true \
-Dmapred.job.map.memory.mb=3076 \
-Dmapred.job.reduce.memory.mb=3076 \
-param UserKeys=$UserKeys \
-param BusinessKeys=$BusinessKeys \
-param Review=$Review \
-param Output=$out
done
done

