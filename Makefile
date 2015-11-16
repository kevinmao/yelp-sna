all: transform split_review core_review_sample
xkeys: user_keys business_keys user_user
xub: ub_review_all
xsim: ub_similarity
xtopn: top_n
xstats: check_user_biz_review review_per_year
xgraph: graph_info
xplot: degree_dist

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

core_review: split_review
	############################################
	### core_review for train and test data
	############################################
	cd docprocess/shell && bash core_review.sh

core_review_sample: split_review
	############################################
	### core_review_sample for train and test data
	############################################
	cd docprocess/shell && bash core_review_sample.sh

generate_graphs:
	############################################
	### generate_graphs on hadoop
	############################################
	cd docprocess/pig && bash generate_graphs.sh


check_user_biz_review: split_review
	############################################
	### check_user_biz_review
	############################################
	cd analysis/shell && bash check_user_biz_review.sh


review_per_year:
	############################################
	### review_per_year
	############################################
	cd analysis/shell && bash review_per_year.sh


#
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


user_keys:
	############################################
	### user keys
	############################################
	cd train/shell && bash user_keys.sh

user_user:
	############################################
	### user user graph
	############################################
	cd train/shell && bash user_user.sh

business_keys:
	############################################
	### business keys
	############################################
	cd train/shell && bash business_keys.sh

ub_review_all:
	############################################
	### ub_review_all graphs
	############################################
	cd train/shell && bash ub_review_all.sh

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

