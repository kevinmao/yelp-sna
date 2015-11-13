#!/bin/bash

## Where am I
export WHERE_AM_I="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

############################################
### global options subject to change
############################################

## Project home
export PROJECT_HOME=${WHERE_AM_I}
export PRJ_NAME=yelp-sna

## Mallet home
export MALLET_HOME=${PROJECT_HOME}/Mallet

############################################
### corpus processing 
############################################
## data processing
export DOC_PROCESS=${PROJECT_HOME}/docprocess
export DOC_PROCESS_SHELL=${DOC_PROCESS}/shell
export DOC_PROCESS_PYTHON=${DOC_PROCESS}/python
export DOC_PROCESS_PIG=${DOC_PROCESS}/pig

## corpus data 
export CORPUS_DATA=${PROJECT_HOME}/yelp_data

## yelp data zipped
export YELP_DATA_ZIP=${CORPUS_DATA}/raw/zip

## yelp data json
export YELP_DATA_JSON=${CORPUS_DATA}/raw/json

## processed data in tsv format
export YELP_DATA_TSV=${CORPUS_DATA}/tsv

## stats data
export YELP_DATA_STATS=${CORPUS_DATA}/stats

## training data
export TRAIN_DATA=${CORPUS_DATA}/train

## test data
export TEST_DATA=${CORPUS_DATA}/test

## local copy of data processed on hadoop
export HDFS_DATA=${CORPUS_DATA}/hdfs

############################################
### Hadoop HDFS
############################################
HDFS_PRJ_HOME=/user/$USER/${PRJ_NAME}
export HDFS_YELP_DATA_TSV=${HDFS_PRJ_HOME}/yelp_data/tsv
export HDFS_TRAIN_DATA=${HDFS_PRJ_HOME}/yelp_data/train
export HDFS_TEST_DATA=${HDFS_PRJ_HOME}/yelp_data/test


############################################
### training and testing
############################################
export TRAINING=${PROJECT_HOME}/train
export TRAINING_SHELL=${TRAINING}/shell
export TRAINING_PYTHON=${TRAINING}/python
export TRAINING_PIG=${TRAINING}/pig

############################################
### analysis
############################################
export STATS=${PROJECT_HOME}/analysis
export STATS_SHELL=${STATS}/shell
export STATS_PYTHON=${STATS}/python
export STATS_PIG=${STATS}/pig





## Mallet data
export MALLET_DATA=${PROJECT_HOME}/mallet-data

############################################
### report and visualization
############################################
export REPORT_DATA=${PROJECT_HOME}/report

############################################
### functions
############################################
# logger
function LOGGER {
    printf "%s %s\n" "[$(date +"%Y-%m-%d %H:%M:%S")]" "$@"
}

