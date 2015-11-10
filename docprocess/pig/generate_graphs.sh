#!/bin/bash

source ../../config.sh

UserKeys=user_keys.tsv
BusinessKeys=business_keys.tsv
Review=review.tsv
WDIR=out
PIGFILE="uu_review_graph.pig bb_review_graph.pig ub_review_graph.pig"

# run
for fpig in `echo $PIGFILE`; do
out=${WDIR}/$(basename $fpig | sed 's/\.pig//g')
hadoop fs -rm -r -skipTrash ${out} >/dev/null 2>&1
pig -useversion 0.11 -f ${DOC_PROCESS_PIG}/${fpig} \
-Dmapred.map.tasks.speculative.execution=true \
-Dmapred.reduce.tasks.speculative.execution=true \
-Dmapred.job.map.memory.mb=3076 \
-Dmapred.job.reduce.memory.mb=3076 \
-param UserKeys=$UserKeys \
-param BusinessKeys=$BusinessKeys \
-param Review=$Review \
-param Output=$out
done

