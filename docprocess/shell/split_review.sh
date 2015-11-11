#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

Review=${YELP_DATA_TSV}/review.tsv
Train=${YELP_DATA_TSV}/review_train.tsv
Test=${YELP_DATA_TSV}/review_test.tsv
Header=${YELP_DATA_TSV}/review.header

# keep header
cat ${Review} | grep 'user_id' > ${Header}

# train data: older than 2014
cat ${Review} | egrep -v '2014|2015-' > ${Train}

# test data: after 2014
cat ${Review} | egrep '2014|2015-' > ${Test}
cat ${Test} >> ${Header}
mv ${Header} ${Test}

