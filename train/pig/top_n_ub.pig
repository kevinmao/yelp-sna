-- Default
%default TOPN 100000
%default SAMPLE_RATE 0.001
%default MIN_COM_NBR 5
%default Predicted ub_similarity.tsv
%default TestCore ub_review_test_core_edges.tsv
%default TruePositive predict_topn

-- Parallel
SET default_parallel 10

--
-- Load data
--
Predicted = LOAD '$Predicted' AS (
    user_id             : long,
    business_id         : long,
    gamma_u             : double,
    gamma_b             : double,
    sim_common_nbr      : double,
    sim_pref            : double,
    sim_jaccard         : double,
    sim_cosine          : double,
    sim_overlap         : double,
    sim_adamic          : double,
    sim_delta           : double
);
Predicted = DISTINCT Predicted;
Predicted = FILTER Predicted BY sim_common_nbr >= $MIN_COM_NBR;
PredictedGrouped = GROUP Predicted ALL;
PredictedSummary = FOREACH PredictedGrouped GENERATE
    (long) $MIN_COM_NBR AS threshold,
    (long) $TOPN AS num_link_topn,
    COUNT($1) AS num_link_cand;
STORE PredictedSummary into '$TopPredicted.summary' using PigStorage('\t', '-schema');

TestCore = LOAD '$TestCore' AS (
    user_id          : long,
    business_id      : long,
    stars            : int
);


--
-- common_nbr
--
common_nbr = ORDER Predicted BY sim_common_nbr DESC, user_id, business_id;
top_common_nbr = LIMIT common_nbr $TOPN;
J = JOIN top_common_nbr BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_common_nbr::user_id, 
    top_common_nbr::business_id, 
    top_common_nbr::sim_common_nbr,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_common_nbr DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.common_nbr' using PigStorage('\t', '-schema');


--
-- pref
--
pref = ORDER Predicted BY sim_pref DESC, user_id, business_id;
top_pref = LIMIT pref $TOPN;
J = JOIN top_pref BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_pref::user_id, 
    top_pref::business_id, 
    top_pref::sim_pref,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_pref DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.pref' using PigStorage('\t', '-schema');

--
-- jaccard
--
jaccard = ORDER Predicted BY sim_jaccard DESC, user_id, business_id;
top_jaccard = LIMIT jaccard $TOPN;
J = JOIN top_jaccard BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_jaccard::user_id, 
    top_jaccard::business_id, 
    top_jaccard::sim_jaccard,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_jaccard DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.jaccard' using PigStorage('\t', '-schema');

--
-- cosine
--
cosine = ORDER Predicted BY sim_cosine DESC, user_id, business_id;
top_cosine = LIMIT cosine $TOPN;
J = JOIN top_cosine BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_cosine::user_id, 
    top_cosine::business_id, 
    top_cosine::sim_cosine,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_cosine DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.cosine' using PigStorage('\t', '-schema');


--
-- overlap
--
overlap = ORDER Predicted BY sim_overlap DESC, user_id, business_id;
top_overlap = LIMIT overlap $TOPN;
J = JOIN top_overlap BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_overlap::user_id, 
    top_overlap::business_id, 
    top_overlap::sim_overlap,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_overlap DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.overlap' using PigStorage('\t', '-schema');


--
-- adamic
--
adamic = ORDER Predicted BY sim_adamic DESC, user_id, business_id;
top_adamic = LIMIT adamic $TOPN;
J = JOIN top_adamic BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_adamic::user_id, 
    top_adamic::business_id, 
    top_adamic::sim_adamic,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_adamic DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.adamic' using PigStorage('\t', '-schema');


--
-- delta
--
delta = ORDER Predicted BY sim_delta DESC, user_id, business_id;
top_delta = LIMIT delta $TOPN;
J = JOIN top_delta BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
TruePositive = FOREACH J GENERATE
    top_delta::user_id, 
    top_delta::business_id, 
    top_delta::sim_delta,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
TruePositive = ORDER TruePositive BY sim_delta DESC, user_id, business_id;
STORE TruePositive into '$TruePositive.delta' using PigStorage('\t', '-schema');
