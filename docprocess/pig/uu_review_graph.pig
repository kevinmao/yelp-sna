-- Default
%default UserKeys user_keys.tsv
%default BusinessKeys business_keys.tsv
%default Review review.tsv
%default Output out

-- Parallel
SET default_parallel 10


DEFINE TRANSFORMER `python transformer.py` ship ('transformer.py');

--
-- Load data
--

USER_KEYS = LOAD '$UserKeys' AS (
	user_id			: long,
	user_str_id		: chararray,
	name			: chararray
);
	
BUSINESS_KEYS = LOAD '$BusinessKeys' AS (
	business_id			: long,
	business_str_id		: chararray,
	name				: chararray
);
	
REVIEW = LOAD '$Review' AS (
    user_str_id			: chararray,
    business_str_id		: chararray,
    stars				: int,
    date				: chararray,
    votes_funny			: int,
    votes_useful		: int,
    votes_cool			: int
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
STORE UUG into '$Output' using PigStorage('\t', '-schema');

