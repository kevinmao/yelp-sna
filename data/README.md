yelp academic dataset
========================

1. Download Url
    
    * http://www.yelp.com/dataset_challenge

2. Raw JSON format data

    ```
	raw/
	├── json
	│   ├── yelp_academic_dataset_business.json
	│   ├── yelp_academic_dataset_checkin.json
	│   ├── yelp_academic_dataset_review.json
	│   ├── yelp_academic_dataset_tip.json
	│   └── yelp_academic_dataset_user.json
	└── zip
    	└── yelp_dataset_challenge_academic_dataset.tgz
    ```
    
3. TSV format data

	```
	tsv/
	├── business.tsv
	├── checkin.tsv
	├── review.tsv
	├── review_test.tsv
	├── review_train.tsv
	├── tip.tsv
	└── user.tsv
	```

4. Training data

	```
	train/
	├── business_keys.tsv
	├── ub_review_all_edges.tsv
	├── ub_review_test_core_all_edges.tsv
	├── ub_review_test_core_edges.tsv
	├── ub_review_test_edges.tsv
	├── ub_review_train_core_all_edges.tsv
	├── ub_review_train_core_edges.tsv
	├── ub_review_train_edges.tsv
	├── ub_review_train_maxwcc_edges.tsv
	├── user_friend_edges.tsv
	└── user_keys.tsv
	```

5. Analysis data

	```
	analysis/
	├── business_hist.pdf
	├── business_hist.tsv
	├── business_hist_all.pdf
	├── business_hist_all.tsv
	├── business_hist_maxwcc.pdf
	├── business_hist_maxwcc.tsv
	├── digree_dist_plot.pdf
	├── graph_info_all.txt
	├── graph_info_test.txt
	├── graph_info_test_core.txt
	├── graph_info_train.txt
	├── graph_info_train_core.txt
	├── review_per_year.tsv
	├── stats.tsv
	├── user_hist.pdf
	├── user_hist.tsv
	├── user_hist_all.pdf
	├── user_hist_all.tsv
	├── user_hist_maxwcc.pdf
	└── user_hist_maxwcc.tsv
	
	```

6. Matrix Factorization data

	```
	mf/
	├── meta
	├── mf_ub_review_test.predicted
	├── mf_ub_review_test.score
	├── mf_ub_review_test.tsv
	├── mf_ub_review_train.tsv
	└── model
	```

7. Hadoop HDFS data

	```
	hdfs/
	├── mf.out.ge.1
	│   ├── link_cand.summary
	│   │   └── part-r-00000
	│   ├── predicted_topn.adamic
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   ├── predicted_topn.common_nbr
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   ├── predicted_topn.cosine
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   ├── predicted_topn.delta
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   ├── predicted_topn.jaccard
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   ├── predicted_topn.overlap
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   ├── predicted_topn.pref
	│   │   ├── part-r-00000
	│   │   ├── ......
	│   └── predicted_topn.pstars
	│   │   ├── part-r-00000
	│   │   ├── ......
	├── mf.out.ge.10
	│   ├── link_cand.summary
	│   │   ├── ......
	```

8. Link prediction data

	```
	predict/
	├── summary
	│   ├── PatN.combined.tsv
	│   ├── TP.combined.augmented.tsv
	│   ├── TP.combined.tsv
	│   ├── link_cand_summary.tsv
	│   ├── mf_precision.T30.tsv
	│   ├── mf_predicted_topn.TP.tsv
	│   ├── precision.T30.tsv
	│   └── predicted_topn.TP.tsv
	└── topn
	    ├── predicted_topn.adamic.T1.tsv
	    ├── ......	
	```
