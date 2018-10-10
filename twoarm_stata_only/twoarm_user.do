simulate estimand = r(estimand) estimate = r(estimate) se = r(se) p = r(p), reps(500): twoarm
local bias r(estimand) - r(estimate)
display `bias'

summarize estimand
summarize estimate
summarize se
summarize p

gen significant = p < 0.05
gen true_positive = p < 0.05 & sign(estimand) == sign(estimand)
summarize true_positive

gen false_positive = p < 0.05 & sign(estimand) != sign(estimand)