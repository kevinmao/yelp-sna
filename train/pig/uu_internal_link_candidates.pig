-- Default
%default UserUserTrain uu_review_train_edges.tsv
%default UserBizTrain ub_review_train_edges.tsv
%default BizBizTrain bb_review_train_edges.tsv
%default Output out

DEFINE TRANSFORMER `python transformer.py` ship ('transformer.py');

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

-- UU Train
UUT1 = FOREACH UserUserTrain GENERATE user1_id AS uid1, user2_id AS uid2;
UUT2 = FOREACH UserUserTrain GENERATE user2_id AS uid1, user1_id AS uid2;
UUT = UNION UUT1, UUT2;
UUT = DISTINCT UUT;

-- Users
Users = FOREACH UserBizTrain GENERATE user_id;
Users = DISTINCT Users;
 
-- Business
Business = FOREACH UserBizTrain GENERATE business_id;
Business = DISTINCT Business;

-- All User-Business pairs
UBCross = CROSS Users, Business;

-- New User-Business pairs
JOUTER = JOIN UBCross BY (user_id, business_id) LEFT OUTER, UserBizTrain BY BY (user_id, business_id);
JDEDUP = FILTER JOUTER BY (UserBizTrain::user_id is null);
UBNew = FOREACH JDEDUP GENERATE 
	UBCross::user_id AS user_id,
	UBCross::business_id AS business_id;

-- Check internal edges
A = FOREACH UBNew {
	B = FILTER UserBizTrain BY (business_id == UBNew.business_id);
	C1 = FOREACH B GENERATE user_id;
	C2 = FOREACH B GENERATE user_id;
	C3 = CROSS C1, C2;
	C4 = FOREACH C3 GENERATE C1::user_id AS uid1, C2::user_id AS uid2;
	D = FILTER C4 BY (uid1 != uid2);
	E = JOIN D BY (uid1, uid2) LEFT OUTER, UUT BY (uid1, uid2);
		
}






	
	
	
















----------------------------------------------------

/*

A = GROUP UserBizTrain BY business_id;
B = FOREACH A GENERATE group AS business, UserBizTrain.user_id AS user;
C = STREAM B THROUGH TRANSFORMER AS (
	user1: long, 
	user2: long 
);



A = GROUP UserBizTrain BY business_id;
B = FOREACH A GENERATE group AS business, UserBizTrain.user_id AS user;
C = STREAM B THROUGH TRANSFORMER AS (
	user1: long, 
	user2: long 
);



A = FOREACH REVIEW GENERATE user_str_id .. business_str_id;

GROUP_BY_USER = GROUP A BY user_str_id;
GROUP_BY_BUSINESS = GROUP A BY business_str_id;
COUNT_BY_USER = FOREACH GROUP_BY_USER GENERATE group AS user, COUNT($1) AS user_reviews;
COUNT_BY_BUSINESS = FOREACH GROUP_BY_BUSINESS GENERATE group AS business, COUNT($1) AS business_reviews;

--
-- user-user graph
--

C = FOREACH GROUP_BY_BUSINESS GENERATE
	group AS business,
	A.user_str_id AS user;

UUB = STREAM C THROUGH TRANSFORMER AS (
	user1: chararray, 
	user2: chararray, 
	business: chararray 
);
DESCRIBE UUB;

GU12 = GROUP UUB BY (user1, user2);
GU12X = FOREACH GU12 GENERATE group.user1 AS user1, group.user2 AS user2, COUNT($1) AS common_reviews;

J0 = JOIN UUB BY user1, COUNT_BY_USER BY user;
J1 = FOREACH J0 GENERATE
	UUB::user1 AS user1,
	UUB::user2 AS user2,
	COUNT_BY_USER::user_reviews AS user1_reviews
	;

J2 = JOIN J1 BY user2, COUNT_BY_USER BY user;
J3 = FOREACH J2 GENERATE 
	J1::user1 AS user1,
	J1::user2 AS user2,
	J1::user1_reviews AS user1_reviews,
	COUNT_BY_USER::user_reviews AS user2_reviews
	;
DESCRIBE J3;

J4 = JOIN J3 BY (user1, user2), GU12X BY (user1, user2);
J5 = FOREACH J4 GENERATE 
	J3::user1 AS user1,
	J3::user2 AS user2,
	J3::user1_reviews AS user1_reviews,
	J3::user2_reviews AS user2_reviews,
	GU12X::common_reviews AS common_reviews
	;
J5 = DISTINCT J5;
DESCRIBE J5;

J6 = JOIN J5 by user1, USER_KEYS BY user_str_id;
J7 = FOREACH J6 GENERATE
	USER_KEYS::user_id AS user1_id,
	J5::user2 AS user2,
	J5::user1_reviews AS user1_reviews,
	J5::user2_reviews AS user2_reviews,
	J5::common_reviews AS common_reviews
	;
DESCRIBE J7;
	
J8 = JOIN J7 by user2, USER_KEYS BY user_str_id;
J9 = FOREACH J8 GENERATE
	J7::user1_id AS user1_id,
	USER_KEYS::user_id AS user2_id,
	J7::user1_reviews AS user1_reviews,
	J7::user2_reviews AS user2_reviews,
	J7::common_reviews AS common_reviews
	;
DESCRIBE J9;

UUG = ORDER J9 BY user1_id, user2_id;
UUG2 = FOREACH UUG GENERATE
	user1_id .. common_reviews,
	(1.0 * common_reviews) / (user1_reviews + user2_reviews) AS jaccard_sim;
STORE UUG2 into '$Output' using PigStorage('\t', '-schema');
*/

