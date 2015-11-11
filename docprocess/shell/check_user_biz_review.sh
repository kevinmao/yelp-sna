#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

prefix=yelp_academic_dataset
output=${YELP_DATA_TSV}/stats.tsv
ftmp=${YELP_DATA_TSV}/stats.tsv.tmp

# user file
echo "------------ users [business] with reviews ------------" > ${ftmp}
python ${DOC_PROCESS_PYTHON}/check_user_biz_review.py \
--user_keys ${YELP_DATA_TSV}/user_keys.tsv \
--business_keys ${YELP_DATA_TSV}/business_keys.tsv \
--review ${YELP_DATA_TSV}/review.tsv \
--output ${output}
cat ${output} >> ${ftmp}

{
echo
echo "------------ users and friends ------------"
ftype=user
python ${DOC_PROCESS_PYTHON}/check_user.py \
--input ${YELP_DATA_JSON}/${prefix}_${ftype}.json

echo 
echo "------------ review per year ------------" 
cat ${YELP_DATA_TSV}/review.tsv | cut -f4 | grep -v date | cut -d- -f1 | sort | uniq -c | sort -k2 | awk '{print $2"\t"$1}'

echo
echo "------------ common (user, review) pairs in train and test data ------------"
python ${DOC_PROCESS_PYTHON}/check_train.py \
--train_data ${YELP_DATA_TSV}/review_train.tsv \
--test_data ${YELP_DATA_TSV}/review_test.tsv
} >> ${ftmp}

mv ${ftmp} ${output}

LOGGER "Done."

