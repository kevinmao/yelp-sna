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
    user_id            : long,
    business_id        : long,
    dummy_value        : double,
    predicted_value    : double
);
-- Predicted = FILTER Predicted BY (predicted_value <= 5.0);

TestCore = LOAD '$TestCore' AS (
    user_id          : long,
    business_id      : long,
    stars            : int
);

A = FOREACH Predicted GENERATE 
    user_id,
    business_id,
    predicted_value;

B = ORDER A BY predicted_value DESC, user_id, business_id;

TopPredicted = LIMIT B $N;
STORE TopPredicted into '$TopPredicted' using PigStorage('\t');

J = JOIN TestCore BY (user_id, business_id), TopPredicted BY (user_id, business_id);
TruePositive = FOREACH J GENERATE TopPredicted::user_id .. TopPredicted::predicted_value;

STORE TruePositive into '$TruePositive' using PigStorage('\t', '-schema');

