-- Default
%default UserUserTrain uu_review_train_edges.tsv
%default UserBizTrain ub_review_train_edges.tsv
%default BizBizTrain bb_review_train_edges.tsv
%default Output out

DEFINE TRANSFORMER `python bu_il_cand.py $BizBizTrain2 $UserBizTrain2` ship ('bu_il_cand.py','$BizBizTrain2','$UserBizTrain2');

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
BizUserTrain = FOREACH UserBizTrain GENERATE business_id, user_id;

-- Users
Users = FOREACH UserBizTrain GENERATE user_id;
Users = DISTINCT Users;
 
-- Business
Business = FOREACH UserBizTrain GENERATE business_id;
Business = DISTINCT Business;

-- All Business-User pairs
BUCross = CROSS Business, Users;
BUCross = FOREACH BUCross GENERATE Business::business_id AS business_id, Users::user_id AS user_id;

-- New Business-User pairs
JOUTER = JOIN BUCross BY (business_id, user_id) LEFT OUTER, BizUserTrain BY (business_id, user_id);
JOUTER = FILTER JOUTER BY (BizUserTrain::business_id is null);
NEW_BU = FOREACH JOUTER GENERATE BUCross::business_id AS business_id, BUCross::user_id AS user_id;

-- Internal links
IL_BU = STREAM NEW_BU THROUGH TRANSFORMER AS (
	business_id: long, 
	user_id: long
);

IL_BU = ORDER IL_BU BY business_id, user_id;
STORE IL_BU into '$Output' using PigStorage('\t', '-schema');

