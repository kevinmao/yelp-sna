all: prepare xkeys ub_review get_maxwcc xcore
xstats: xgraph xcheck xplot
xsim: ub_similarity
xtopn: top_n
xpredicted: predicted_topn predicted_tp
xcand: link_cand_summary

prepare: transform split_review
xkeys: user_keys business_keys user_user
xcore: core_review core_review_sample

xgraph: graph_info
xcheck: check_user_review review_per_year
xplot: degree_dist

### ----------------------------------------------------
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

split_review:
	############################################
	### split_review into train and test
	############################################
	cd docprocess/shell && bash split_review.sh

### ----------------------------------------------------
user_keys:
	############################################
	### user keys
	############################################
	cd train/shell && bash user_keys.sh

business_keys:
	############################################
	### business keys
	############################################
	cd train/shell && bash business_keys.sh

user_user:
	############################################
	### user user graph
	############################################
	cd train/shell && bash user_user.sh

ub_review:
	############################################
	### ub_review graphs
	############################################
	cd train/shell && bash ub_review.sh

get_maxwcc:
	############################################
	### get_maxwcc
	############################################
	cd train/shell && bash get_maxwcc.sh

### ----------------------------------------------------
core_review:
	############################################
	### core_review for train and test data
	############################################
	cd train/shell && bash core_review.sh

core_review_sample:
	############################################
	### core_review_sample for train and test data
	############################################
	cd train/shell && bash core_review_sample.sh

generate_graphs:
	############################################
	### generate_graphs on hadoop
	############################################
	cd docprocess/pig && bash generate_graphs.sh


### ----------------------------------------------------
check_user_review:
	############################################
	### check_user_review
	############################################
	cd analysis/shell && bash check_user_review.sh


review_per_year:
	############################################
	### review_per_year
	############################################
	cd analysis/shell && bash review_per_year.sh


graph_info:
	############################################
	### graph_info
	############################################
	cd analysis/shell && bash graph_info.sh


degree_dist:
	############################################
	### degree_dist
	############################################
	cd analysis/shell && bash degree_dist.sh

histgram:
	############################################
	### histgram
	############################################
	cd analysis/shell && bash histgram.sh


### ----------------------------------------------------
ub_similarity:
	############################################
	### ub_similarity
	############################################
	cd train/shell && bash ub_similarity.sh

top_n:
	############################################
	### topn predicted on hadoop
	############################################
	cd train/pig && bash top_n.sh

predicted_topn:
	############################################
	### predicted_topn
	############################################
	cd train/shell && bash predicted_topn.sh

predicted_tp:
	############################################
	### predicted_tp
	############################################
	cd train/shell && bash predicted_tp.sh


link_cand_summary:
	############################################
	### link_cand_summary
	############################################
	cd train/shell && bash link_cand_summary.sh


### ----------------------------------------------------
create_mf_data:
	############################################
	### create_mf_data
	############################################
	cd train/shell && bash create_mf_data.sh

mf_train:
	############################################
	### mf_train
	############################################
	cd train/shell && bash mf_train.sh


### ----------------------------------------------------
create_induced_graphs:
	############################################
	### create_induced_graphs
	### based on the results from generate_graphs
	############################################
	cd train/shell && bash create_induced_graphs.sh

create_internal_link_candidates:
	############################################
	### create_internal_link_candidates
	############################################
	cd train/shell && bash create_internal_link_candidates.sh

cross_prod:
	############################################
	### cross_prod
	############################################
	cd train/shell && bash cross_prod.sh
### ----------------------------------------------------
