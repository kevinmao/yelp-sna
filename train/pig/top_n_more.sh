#!/bin/bash

source ../../config.sh

N=100000
Predicted=ub_similarity.tsv
TestCore=ub_review_test_core_edges.tsv
TopPredicted=predict_topn
TruePositive=predict_topn.TP
{
hadoop fs -rm -r -skipTrash ${TruePositive}* ${TopPredicted}*
} >/dev/null 2>&1

fpig=top_n_ub_more.pig

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
