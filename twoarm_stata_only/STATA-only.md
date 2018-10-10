---
title: 'STATA-only' option for DeclareDesign
author: Pete Mohanty
date: October 10th, 2018
---

`STATA-only` is based on an [rclass program](https://github.com/DeclareDesign/MATA/blob/master/twoarm_stata_only/twoarm.ado), which declares, simulates, and estimates. First, the environment is initialized.

```STATA
program twoarm, rclass
  version 15
  drop _all
  local N = 100
  set obs `N'

```
Users could replace the above to use existing data. Next, constants are initialized as `locals`:

```STATA
  local assignment_prob  =  0.5
  local control_mean  =  0
```
Next, vectors corresponding to treatment and control are simulated as `STATA variables`. Here's another excerpt:
```STATA
  gen u_0 = rnormal()
  gen Z = runiform() < `assignment_prob'
  gen Y_Z_0 = (1-Z)*(u_0*`control_sd' + `control_mean')
```
Finally, quantities of interest can be returned like so:
```STATA
  gen tau = Y_Z_1 - Y_Z_0
  summarize tau
  return scalar estimand = r(mean)
  
  regress Y Z
  local estimate _b[Z]
  return scalar estimate = `estimate'
```
Here's the simulation command:
```STATA
simulate estimand = r(estimand) estimate = r(estimate) se = r(se) p = r(p), reps(500): twoarm
```
A companion [do file](https://github.com/DeclareDesign/MATA/blob/master/twoarm_stata_only/twoarm_user.do) shows some postestimation commands of interest. 
```STATA
local bias r(estimand) - r(estimate)
display `bias'

summarize estimate
summarize p

gen true_positive = p < 0.05 & sign(estimand) == sign(estimand)
summarize true_positive
```