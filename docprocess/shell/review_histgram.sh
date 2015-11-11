#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_STATS}

python ${DOC_PROCESS_PYTHON}/review_histgram.py \
--review ${YELP_DATA_TSV}/review.tsv \
--output_hist_user ${YELP_DATA_STATS}/hist_user \
--output_hist_business ${YELP_DATA_STATS}/hist_business

LOGGER "Done."
