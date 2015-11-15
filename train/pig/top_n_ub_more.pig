-- Default
%default N 100000
%default Predicted mf.ub_cross_prod.rating
%default TestCore ub_review_test_core_edges.tsv
%default TruePositive mf.rating.tp

-- Parallel
SET default_parallel 10

--
-- Load data
--
Predicted = LOAD '$Predicted' AS (
    user_id      		: long,
    business_id        	: long,
    gamma_u	        	: double,
    gamma_b	        	: double,
    sim_common_nbr      : double,
    sim_pref            : double,
    sim_jaccard        	: double,
    sim_cosine        	: double,
    sim_overlap        	: double,
    sim_adamic        	: double,
    sim_delta    		: double
);
Predicted = DISTINCT Predicted;

TestCore = LOAD '$TestCore' AS (
    user_id          : long,
    business_id      : long,
    stars            : int
);

--
-- common_nbr
--
common_nbr = ORDER Predicted BY sim_common_nbr DESC, user_id, business_id;
top_common_nbr = LIMIT common_nbr $N;
STORE top_common_nbr into '$TopPredicted.common_nbr' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_common_nbr BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_common_nbr::user_id, top_common_nbr::business_id, top_common_nbr::sim_common_nbr;
STORE TruePositive into '$TruePositive.common_nbr' using PigStorage('\t');

--
-- pref
--
pref = ORDER Predicted BY sim_pref DESC, user_id, business_id;
top_pref = LIMIT pref $N;
STORE top_pref into '$TopPredicted.pref' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_pref BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_pref::user_id, top_pref::business_id, top_pref::sim_pref;
STORE TruePositive into '$TruePositive.pref' using PigStorage('\t');

--
-- jaccard
--
jaccard = ORDER Predicted BY sim_jaccard DESC, user_id, business_id;
top_jaccard = LIMIT jaccard $N;
STORE top_jaccard into '$TopPredicted.jaccard' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_jaccard BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_jaccard::user_id, top_jaccard::business_id, top_jaccard::sim_jaccard;
STORE TruePositive into '$TruePositive.jaccard' using PigStorage('\t');

--
-- cosine
--
cosine = ORDER Predicted BY sim_cosine DESC, user_id, business_id;
top_cosine = LIMIT cosine $N;
STORE top_cosine into '$TopPredicted.cosine' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_cosine BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_cosine::user_id, top_cosine::business_id, top_cosine::sim_cosine;
STORE TruePositive into '$TruePositive.cosine' using PigStorage('\t');

--
-- overlap
--
overlap = ORDER Predicted BY sim_overlap DESC, user_id, business_id;
top_overlap = LIMIT overlap $N;
STORE top_overlap into '$TopPredicted.overlap' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_overlap BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_overlap::user_id, top_overlap::business_id, top_overlap::sim_overlap;
STORE TruePositive into '$TruePositive.overlap' using PigStorage('\t');


--
-- adamic
--
adamic = ORDER Predicted BY sim_adamic DESC, user_id, business_id;
top_adamic = LIMIT adamic $N;
STORE top_adamic into '$TopPredicted.adamic' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_adamic BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_adamic::user_id, top_adamic::business_id, top_adamic::sim_adamic;
STORE TruePositive into '$TruePositive.adamic' using PigStorage('\t');


--
-- delta
--
delta = ORDER Predicted BY sim_delta DESC, user_id, business_id;
top_delta = LIMIT delta $N;
STORE top_delta into '$TopPredicted.delta' using PigStorage('\t');
J = JOIN TestCore BY (user_id, business_id), top_delta BY (user_id, business_id);
TruePositive = FOREACH J GENERATE top_delta::user_id, top_delta::business_id, top_delta::sim_delta;
STORE TruePositive into '$TruePositive.delta' using PigStorage('\t');


