all: transform split_review
xtrain: user_keys business_keys user_user
xstats: review_histgram check_user_biz_review

xunzip:
	############################################
	### uncompress yelp data
	############################################
	cd docprocess/shell && bash xunzip.sh

transform:
	############################################
	### generate data in tsv format
	############################################
	cd docprocess/shell && bash transform.sh

user_keys:
	############################################
	### user keys
	############################################
	cd docprocess/shell && bash user_keys.sh

user_user:
	############################################
	### user user graph
	############################################
	cd docprocess/shell && bash user_user.sh

business_keys:
	############################################
	### business keys
	############################################
	cd docprocess/shell && bash business_keys.sh

ub_review_all:
	############################################
	### ub_review_all graph
	############################################
	cd docprocess/shell && bash ub_review_all.sh

split_review:
	############################################
	### split_review into train and test
	############################################
	cd docprocess/shell && bash split_review.sh

check_user_biz_review: split_review
	############################################
	### check_user_biz_review
	############################################
	cd docprocess/shell && bash check_user_biz_review.sh

review_histgram:
	############################################
	### review_histgram
	############################################
	cd docprocess/shell && bash review_histgram.sh

generate_graphs:
	############################################
	### generate_graphs
	############################################
	cd docprocess/pig && bash generate_graphs.sh

clean:
	############################################
	### clean up email body
	############################################
	cd docprocess/shell && bash clean.sh

genfeat:
	############################################
	### create training data 
	############################################
	cd feature && bash genfeat.sh

import:
	############################################
	### create mallet format data 
	############################################
	cd train && bash import.sh

lite:
	############################################
	### lite weight pipeline test
	############################################
	cd train && bash lite.sh

train_unigram:
	############################################
	### train unigram model 
	############################################
	cd train && bash train.sh unigram

train_bigram:
	############################################
	### train bigram model 
	############################################
	cd train && bash train.sh bigram

train_unibigram:
	############################################
	### train unigram+bigram model 
	############################################
	cd train && bash train.sh uni+bigram

evaluate_unigram:
	############################################
	### evaluate unigram model 
	############################################
	cd train && bash evaluate.sh unigram

evaluate_bigram:
	############################################
	### evaluate bigram model 
	############################################
	cd train && bash evaluate.sh bigram

evaluate_unibigram:
	############################################
	### evaluate unigram+bigram model 
	############################################
	cd train && bash evaluate.sh uni+bigram

infer_unigram:
	############################################
	### infer unigram model 
	############################################
	cd train && bash infer.sh unigram

infer_bigram:
	############################################
	### infer bigram model 
	############################################
	cd train && bash infer.sh bigram

infer_unibigram:
	############################################
	### infer unigram+bigram model 
	############################################
	cd train && bash infer.sh uni+bigram

doclen_unigram:
	############################################
	### testdoc_len unigram model 
	############################################
	cd train && bash doclen.sh unigram

doclen_bigram:
	############################################
	### testdoc_len bigram model 
	############################################
	cd train && bash doclen.sh bigram

doclen_unibigram:
	############################################
	### testdoc_len unigram+bigram model 
	############################################
	cd train && bash doclen.sh uni+bigram

perplexity:
	############################################
	### calculate perplexity scores
	############################################
	cd viz && bash perplexity.sh 

topic_dist:
	############################################
	### calculate topic dist.
	############################################
	echo "cd viz && octave topic_dist.m"
	echo "cd viz && octave plot_topic_dist.m"

topwords:
	############################################
	### Get word counts for top 5 topics
	### inferred by the trained model
	############################################
	cd viz && bash topwords.sh

primarytopics:

	############################################
	### primary topic to num-of-docs
	############################################
	cd viz && bash primarytopics.sh

