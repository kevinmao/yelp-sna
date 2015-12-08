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

		