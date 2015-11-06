#!/bin/bash

# global vars
source ../../config.sh

# reset
rm -fr ${YELP_DATA_JSON}
mkdir -p ${YELP_DATA_JSON}

prefix="yelp_dataset_challenge_academic_dataset"
tar xvfz ${YELP_DATA_ZIP}/${prefix}.tgz -C ${YELP_DATA_JSON}
mv ${YELP_DATA_JSON}/${prefix}/* ${YELP_DATA_JSON}
rm -fr ${YELP_DATA_JSON}/${prefix}
rm -f ${YELP_DATA_JSON}/*pdf

