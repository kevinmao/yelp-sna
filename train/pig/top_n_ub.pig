-- Default
%default TOPN 100000
%default MIN_COM_NBR 5
%default LinkCand ub_similarity.tsv
%default TestCore ub_review_test_core_edges.tsv
%default LinkCandPruned link_cand
%default PredictedTopN predicted_topn

-- Parallel
SET default_parallel 10

--
-- Load data
--
LinkCand = LOAD '$LinkCand' AS (
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
LinkCand = DISTINCT LinkCand;
LinkCandPruned = FILTER LinkCand BY sim_common_nbr >= $MIN_COM_NBR;
STORE LinkCandPruned into '$LinkCandPruned' using PigStorage('\t', '-schema');

LinkCandPrunedGrouped = GROUP LinkCandPruned ALL;
LinkCandPrunedSummary = FOREACH LinkCandPrunedGrouped GENERATE
    (long) $MIN_COM_NBR AS threshold,
    (long) $TOPN AS num_link_topn,
    COUNT($1) AS num_link_cand;
STORE LinkCandPrunedSummary into '$LinkCandPruned.summary' using PigStorage('\t', '-schema');

TestCore = LOAD '$TestCore' AS (
    user_id          : long,
    business_id      : long,
    stars            : int
);

--
-- random
--
A = FOREACH LinkCandPrunedGrouped GENERATE COUNT(LinkCandPruned) as num_rows;
random = SAMPLE LinkCandPruned 0.0005+$TOPN/(double)A.num_rows;
top_random = LIMIT random $TOPN;
J = JOIN top_random BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_random::user_id AS user_id,
    top_random::business_id AS business_id,
    (double)1.0 AS sim_random,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
STORE PredictedTopN into '$PredictedTopN.random' using PigStorage('\t', '-schema');


--
-- common_nbr
--
common_nbr = ORDER LinkCandPruned BY sim_common_nbr DESC, user_id, business_id;
top_common_nbr = LIMIT common_nbr $TOPN;
J = JOIN top_common_nbr BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_common_nbr::user_id AS user_id,
    top_common_nbr::business_id AS business_id,
    top_common_nbr::sim_common_nbr AS sim_common_nbr,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_common_nbr DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.common_nbr' using PigStorage('\t', '-schema');


--
-- pref
--
pref = ORDER LinkCandPruned BY sim_pref DESC, user_id, business_id;
top_pref = LIMIT pref $TOPN;
J = JOIN top_pref BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_pref::user_id AS user_id,
    top_pref::business_id AS business_id,
    top_pref::sim_pref AS sim_pref,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_pref DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.pref' using PigStorage('\t', '-schema');

--
-- jaccard
--
jaccard = ORDER LinkCandPruned BY sim_jaccard DESC, user_id, business_id;
top_jaccard = LIMIT jaccard $TOPN;
J = JOIN top_jaccard BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_jaccard::user_id AS user_id,
    top_jaccard::business_id AS business_id,
    top_jaccard::sim_jaccard AS sim_jaccard,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_jaccard DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.jaccard' using PigStorage('\t', '-schema');

--
-- cosine
--
cosine = ORDER LinkCandPruned BY sim_cosine DESC, user_id, business_id;
top_cosine = LIMIT cosine $TOPN;
J = JOIN top_cosine BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_cosine::user_id AS user_id,
    top_cosine::business_id AS business_id,
    top_cosine::sim_cosine AS sim_cosine,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_cosine DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.cosine' using PigStorage('\t', '-schema');


--
-- overlap
--
overlap = ORDER LinkCandPruned BY sim_overlap DESC, user_id, business_id;
top_overlap = LIMIT overlap $TOPN;
J = JOIN top_overlap BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_overlap::user_id AS user_id,
    top_overlap::business_id AS business_id,
    top_overlap::sim_overlap AS sim_overlap,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_overlap DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.overlap' using PigStorage('\t', '-schema');


--
-- adamic
--
adamic = ORDER LinkCandPruned BY sim_adamic DESC, user_id, business_id;
top_adamic = LIMIT adamic $TOPN;
J = JOIN top_adamic BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_adamic::user_id AS user_id,
    top_adamic::business_id AS business_id,
    top_adamic::sim_adamic AS sim_adamic,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_adamic DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.adamic' using PigStorage('\t', '-schema');


--
-- delta
--
delta = ORDER LinkCandPruned BY sim_delta DESC, user_id, business_id;
top_delta = LIMIT delta $TOPN;
J = JOIN top_delta BY (user_id, business_id) left outer, TestCore BY (user_id, business_id);
PredictedTopN = FOREACH J GENERATE
    top_delta::user_id AS user_id,
    top_delta::business_id AS business_id,
    top_delta::sim_delta AS sim_delta,
    ((TestCore::user_id is null) ? 0 : 1) AS tp_flag;
PredictedTopN = ORDER PredictedTopN BY sim_delta DESC, user_id, business_id;
STORE PredictedTopN into '$PredictedTopN.delta' using PigStorage('\t', '-schema');
