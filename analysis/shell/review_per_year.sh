#!/bin/bash

# global vars
source ../../config.sh 
mkdir -p ${YELP_DATA_STATS}

LOGGER "START..."

output=${YELP_DATA_STATS}/review_per_year.tsv

cat ${YELP_DATA_TSV}/review.tsv | cut -f4 | grep -v date | cut -d- -f1 | sort | uniq -c | sort -k2 | awk '{print $2"\t"$1}' > ${output}

LOGGER "Done."

