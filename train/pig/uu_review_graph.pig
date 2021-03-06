-- Default
%default Review ub_review_train_core_edges.tsv
%default Output out

-- Parallel
SET default_parallel 10

DEFINE TRANSFORMER `python transformer.py` ship ('transformer.py');

--
-- Load data
--
REVIEW = LOAD '$Review' AS (
    user_id			: long,
    business_id		: long,
    stars			: int
);

GROUP_BY_USER = GROUP REVIEW BY user_id;
GROUP_BY_BUSINESS = GROUP REVIEW BY business_id;
COUNT_BY_USER = FOREACH GROUP_BY_USER GENERATE group AS user, COUNT($1) AS user_reviews;
COUNT_BY_BUSINESS = FOREACH GROUP_BY_BUSINESS GENERATE group AS business, COUNT($1) AS business_reviews;

--
-- user-user graph
--
C = FOREACH GROUP_BY_BUSINESS GENERATE
	group AS business,
	REVIEW.user_id AS user;

UUB = STREAM C THROUGH TRANSFORMER AS (
	user1_id: long, 
	user2_id: long, 
	business: long 
);
UUB = DISTINCT UUB;
DESCRIBE UUB;

GU12 = GROUP UUB BY (user1_id, user2_id);
GU12X = FOREACH GU12 GENERATE group.user1_id AS user1_id, group.user2_id AS user2_id, COUNT($1) AS sim_common_nbr;

J0 = JOIN UUB BY user1_id, COUNT_BY_USER BY user;
J1 = FOREACH J0 GENERATE
	UUB::user1_id AS user1_id,
	UUB::user2_id AS user2_id,
	COUNT_BY_USER::user_reviews AS user1_reviews
	;

J2 = JOIN J1 BY user2_id, COUNT_BY_USER BY user;
J3 = FOREACH J2 GENERATE 
	J1::user1_id AS user1_id,
	J1::user2_id AS user2_id,
	J1::user1_reviews AS user1_reviews,
	COUNT_BY_USER::user_reviews AS user2_reviews
	;
DESCRIBE J3;

J4 = JOIN J3 BY (user1_id, user2_id), GU12X BY (user1_id, user2_id);
J5 = FOREACH J4 GENERATE 
	J3::user1_id AS user1_id,
	J3::user2_id AS user2_id,
	J3::user1_reviews AS user1_reviews,
	J3::user2_reviews AS user2_reviews,
	GU12X::sim_common_nbr AS sim_common_nbr
	;
J5 = DISTINCT J5;
DESCRIBE J5;

UUG = ORDER J9 BY user1_id, user2_id;
UUG2 = FOREACH UUG GENERATE
	user1_id .. sim_common_nbr,
	(user1_reviews * user2_reviews) AS sim_pref,
	(1.0 * sim_common_nbr) / (user1_reviews * user2_reviews) AS sim_cosine,
	(1.0 * sim_common_nbr) / (user1_reviews + user2_reviews) AS sim_jaccard;
STORE UUG2 into '$Output' using PigStorage('\t', '-schema');

