#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_STATS}

LOGGER "START..."

prefix=yelp_academic_dataset
output=${YELP_DATA_STATS}/stats.tsv
ftmp=${YELP_DATA_STATS}/stats.tsv.tmp

# user file
echo "------------ users [business] with reviews ------------" > ${ftmp}
python ${STATS_PYTHON}/check_user_review.py \
--user_keys ${TRAIN_DATA}/user_keys.tsv \
--business_keys ${TRAIN_DATA}/business_keys.tsv \
--review ${YELP_DATA_TSV}/review.tsv \
--output ${output}
cat ${output} >> ${ftmp}

{
echo
echo "------------ users and friends ------------"
ftype=user
python ${STATS_PYTHON}/check_user.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json

echo
echo "------------ common (user, business) edges in train and test data ------------"
python ${STATS_PYTHON}/check_common_edges.py \
--train_data ${TRAIN_DATA}/ub_review_train_core_edges.tsv \
--test_data ${TRAIN_DATA}/ub_review_test_core_edges.tsv
} >> ${ftmp}

mv ${ftmp} ${output}

LOGGER "Done."

