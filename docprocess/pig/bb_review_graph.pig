-- Default
%default UserKeys user_keys.tsv
%default BusinessKeys business_keys.tsv
%default Review review.tsv
%default Output out

-- Parallel
SET default_parallel 1


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

C = FOREACH GROUP_BY_USER GENERATE
	group AS user,
	A.business_str_id AS business;

BBU = STREAM C THROUGH TRANSFORMER AS (
	business1: chararray, 
	business2: chararray, 
	user: chararray 
);
DESCRIBE BBU;

GB12 = GROUP BBU BY (business1, business2);
GB12X = FOREACH GB12 GENERATE group.business1 AS business1, group.business2 AS business2, COUNT($1) AS common_reviews;

J0 = JOIN BBU BY business1, COUNT_BY_BUSINESS BY business;
J1 = FOREACH J0 GENERATE
	BBU::business1 AS business1,
	BBU::business2 AS business2,
	COUNT_BY_BUSINESS::business_reviews AS business1_reviews
	;

J2 = JOIN J1 BY business2, COUNT_BY_BUSINESS BY business;
J3 = FOREACH J2 GENERATE 
	J1::business1 AS business1,
	J1::business2 AS business2,
	J1::business1_reviews AS business1_reviews,
	COUNT_BY_BUSINESS::business_reviews AS business2_reviews
	;
DESCRIBE J3;

J4 = JOIN J3 BY (business1, business2), GB12X BY (business1, business2);
J5 = FOREACH J4 GENERATE 
	J3::business1 AS business1,
	J3::business2 AS business2,
	J3::business1_reviews AS business1_reviews,
	J3::business2_reviews AS business2_reviews,
	GB12X::common_reviews AS common_reviews
	;
J5 = DISTINCT J5;
DESCRIBE J5;

J6 = JOIN J5 by business1, BUSINESS_KEYS BY business_str_id;
J7 = FOREACH J6 GENERATE
	BUSINESS_KEYS::business_id AS business1_id,
	J5::business2 AS business2,
	J5::business1_reviews AS business1_reviews,
	J5::business2_reviews AS business2_reviews,
	J5::common_reviews AS common_reviews
	;
DESCRIBE J7;
	
J8 = JOIN J7 by business2, BUSINESS_KEYS BY business_str_id;
J9 = FOREACH J8 GENERATE
	J7::business1_id AS business1_id,
	BUSINESS_KEYS::business_id AS business2_id,
	J7::business1_reviews AS business1_reviews,
	J7::business2_reviews AS business2_reviews,
	J7::common_reviews AS common_reviews
	;
DESCRIBE J9;

BBG = ORDER J9 BY business1_id, business2_id;
STORE BBG into '$Output' using PigStorage('\t', '-schema');

