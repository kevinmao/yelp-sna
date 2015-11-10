-- Default
%default UserKeys user_keys.tsv
%default BusinessKeys business_keys.tsv
%default Review review.tsv
%default Output out

-- Parallel
SET default_parallel 1

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


A = FOREACH REVIEW GENERATE user_str_id .. stars;
B = JOIN A BY user_str_id, USER_KEYS BY user_str_id;
C = FOREACH B GENERATE
	USER_KEYS::user_id AS user_id,
	A::business_str_id AS business_str_id,
	A::stars AS stars
	;
D = JOIN C BY business_str_id, BUSINESS_KEYS BY business_str_id;
E = FOREACH D GENERATE
	C::user_id AS user_id,
	BUSINESS_KEYS::business_id AS business_id,
	C::stars AS stars
	;

UBG = ORDER E BY user_id, business_id;
STORE UBG into '$Output' using PigStorage('\t', '-schema');

