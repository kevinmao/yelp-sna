-- Default
%default UserUserTrain uu_review_train_edges.tsv
%default UserBizTrain ub_review_train_edges.tsv
%default BizBizTrain bb_review_train_edges.tsv
%default Output out

DEFINE TRANSFORMER `python ub_il_cand.py $UserUserTrain2 $UserBizTrain2` ship ('ub_il_cand.py','$UserUserTrain2','$UserBizTrain2');

-- Parallel
SET default_parallel 10

--
-- Load data
--
UserUserTrain = LOAD '$UserUserTrain' AS (
	user1_id			: long,
	user2_id			: long,
	user1_reviews		: long,
	user2_reviews		: long,
	common_reviews		: long,
	jaccard_sim			: double
);
	
BizBizTrain = LOAD '$BizBizTrain' AS (
	business1_id		: long,
	business2_id		: long,
	business1_reviews	: long,
	business2_reviews	: long,
	common_reviews		: long,
	jaccard_sim			: double
);
	
UserBizTrain = LOAD '$UserBizTrain' AS (
    user_id			: long,
    business_id		: long,
    stars			: long
);

-- Users
Users = FOREACH UserBizTrain GENERATE user_id;
Users = DISTINCT Users;
 
-- Business
Business = FOREACH UserBizTrain GENERATE business_id;
Business = DISTINCT Business;

-- All User-Business pairs
UBCross = CROSS Users, Business;
UBCross = FOREACH UBCross GENERATE Users::user_id AS user_id, Business::business_id AS business_id;

-- New User-Business pairs
JOUTER = JOIN UBCross BY (user_id, business_id) LEFT OUTER, UserBizTrain BY (user_id, business_id);
JOUTER = FILTER JOUTER BY (UserBizTrain::user_id is null);
NEW_UB = FOREACH JOUTER GENERATE UBCross::user_id AS user_id, UBCross::business_id AS business_id;

-- Internal links
UB_IL = STREAM NEW_UB THROUGH TRANSFORMER AS (
	user_id: long, 
	business_id: long 
);

UB_IL = ORDER UB_IL BY user_id, business_id;
STORE UB_IL into '$Output' using PigStorage('\t', '-schema');

