#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_STATS}

prefix=yelp_academic_dataset
output=${YELP_DATA_STATS}/stats.tsv
ftmp=${YELP_DATA_STATS}/stats.tsv.tmp

# user file
echo "------------ users [business] with reviews ------------" > ${ftmp}
python ${STATS_PYTHON}/check_user_biz_review.py \
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
echo "------------ review per year ------------" 
cat ${YELP_DATA_TSV}/review.tsv | cut -f4 | grep -v date | cut -d- -f1 | sort | uniq -c | sort -k2 | awk '{print $2"\t"$1}'

echo
echo "------------ common (user, review) pairs in train and test data ------------"
python ${STATS_PYTHON}/check_train.py \
--train_data ${YELP_DATA_TSV}/review_train_core.tsv \
--test_data ${YELP_DATA_TSV}/review_test_core.tsv
} >> ${ftmp}

mv ${ftmp} ${output}

LOGGER "Done."

