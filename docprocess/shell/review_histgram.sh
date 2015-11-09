#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_TSV}

python ${DOC_PROCESS_PYTHON}/review_histgram.py \
--review ${YELP_DATA_TSV}/review.tsv \
--output_hist_user ${YELP_DATA_TSV}/hist_user \
--output_hist_business ${YELP_DATA_TSV}/hist_business

LOGGER "Done."
