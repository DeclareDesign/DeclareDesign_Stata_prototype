---
title: Simple two-arm design with STATA/MATA
author: Pete Mohanty
date: September 10th, 2018
---

This document shows how to implement the simple two-arm design described [here for R](https://declaredesign.org/library/articles/simple_two_arm.html) in `STATA` (with the help of `MATA`, which is used to create an object which does not require immediate execution). After executing the code, this document describes promises and pitfalls to extending `STATA`. In particular, this document highlights trade-offs between customizablility and user-friendliness by way of examples. Finally, it closes with brief discussion and recommendations. 

# Setup

The files used in the next step are found in [https://github.com/DeclareDesign/MATA/two-arm](https://github.com/DeclareDesign/MATA/two-arm). 
(The files should be in a folder `STATA` recognizes; list with `sysdir`).

```
git clone https://github.com/DeclareDesign/MATA/
stata
sysdir set PERSONAL "~/MATA/two_arm"
personal dir
```
The above should yield something like
```STATA
. personal dir
your personal ado-directory is ~/MATA/two_arm/

declare_programs.ado  design.mo  diagnose.ado  two_arm_designer.ado  two_arm.md
```


# simple_two_arm_designer() 

Here is an approach that starts the user off in `STATA` and then displays to the user how to enter the relevant constants (using very basic `MATA` syntax). 

```STATA
two_arm_designer mydesign
```
That will initialize the design and prompt users about their options.
```STATA
New two arm design stored as:
  mydesign
The underlying population is distributed:
U_0 ~ Normal(0, 1)
U_1 ~ Normal(U_0, sqrt(1 - rho^2))

with potential outcomes:
Y := (1 - Z) :* (u_0 :* control_sd + control_mean) + Z:* (u_1 :* treatment_sd + treatment_mean))

You may wish to alter the following constants:
   N (default: 100), N_sims (default: 500),
   assignment_prob (default: 0.5),
   control_mean (default: 0), control_sd (default: 1),
   treatment_mean (default: 0.5), treatment_sd (default: 1),
   rho (default: 1),
   estimand (default: 'ATE'),
   seed: 4555

Update parameters as follows:
   mata: mydesign.N = 1000
   mata: mydesign.rho = .4

Finally, to diagnose run the STATA command:
   diagnose [designname]
   diagnose mydesign
```
At this point, the `design` object is created and the user can change any of the above mentioned parameters. For example,
```STATA
mata: mydesign.N = 600
mata: mydesign.treatment_mean = .3
```
Once everything is set, to diagnose one simply runs:

```STATA
diagnose mydesign
```
which yields ...

```STATA
. diagnose mydesign

Starting diagnosis...

  seed set to 348872

  Research design diagnosis based on 500 simulations. Diagnosand estimates:

  Design label: two_arm
  Estimand label: ATE
  Estimator label: OLS
  N sims: 500
  Bias: .0058667
  Mean Estimate: .3058667
  SD Estimate: .0824047
  Mean estimand: .3
  Type S error rate: 0

All estimates may accessed as follows:
   mata: mydesign.Mean_Estimate
   mata: mydesign.Type_S_Rate
```

# How the above works

The above program works by having two `ado` files, [two_arm_designer](https://github.com/DeclareDesign/MATA/blob/master/two_arm/two_arm_designer.ado) and [diagnose](https://github.com/DeclareDesign/MATA/blob/master/two_arm/diagnose.ado). The user calls `two_arm_designer`, which initializes a new `design`, with the desired name, with the relevant constants. The user then may leave them alone or alter them in part or in whole. When the user is ready, they call `diagnose`, which generates the appropriate number of simulations and test statistics. Under the hood, [design](https://github.com/DeclareDesign/MATA/blob/master/two_arm/design_mata_source) is a custom `class` written in `MATA`. No objects (well, no matrices) are created until `diagnose` is called from `STATA`. After setting the `seed`, here is the key `STATA` code:

```STATA
  mata: `1'.pop()
  mata: `1'.assign()
  mata: `1'.PO()
  mata: `1'.estimand()
  mata: `1'.Estimator()
```

- [design](https://github.com/DeclareDesign/MATA/blob/master/two_arm/design_mata_source) deliberately has no file extension so that `STATA` will grab `design.mo` from `personal` as opposed to that file. 
- Unlike some code from earlier this summer, this version has a single class for both the design and the diagnosis. It could be split up (or perhaps there could be much a much narrower class that's extended to a 'two_arm' class, which could perhaps also be split up).


# Customizability vs. User-Friendliness

Despite the `STATA` wrapper, the core of this version of the two arm design is written in `MATA`. That has certain advantages: (1) the simulation can be delayed until all constants are set and (2) constants may be set by variable name, as opposed to a very lengthy `STATA` program call. 

Similar in spirit to the `R` version, where one is free to either call `two_arm_designer()` or to initialize the design with a series of function calls (`declare_population()`, `potential_outcomes()`, etc.), one could construct the design this way using the above `class`. There are some differences though. With a `MATA` `class`, one does not call the functions until runtime. The relevant variables are initialized to be called later. This approach would look something like [two_arm_designer](https://github.com/DeclareDesign/MATA/blob/master/two_arm/two_arm_designer.ado). For example, starting from `STATA`:

```STATA
mata
a = design()
a.N = 10000
a.N_sims = 100
```
One major limitation is that `MATA` code, once compiled, is not `interactive`. You cannot add new variables to the class `design`.
```STATA
mata
a = design()
a.W = 100 /* throws an error: W not found in class design */
```
In theory, a savy user could initialize that unanticipated variable in the `MATA` environment but it would be very difficult for the `class` `functions` to know how to refer to it at runtime (possibly impossible).

A user aware of that limitation and familiar with basic `MATA` syntax could (i.e., could be enabled to) customize like so.

```MATA
a = design()
a.estimator = "Y := (1 - Z) :* (u_0 :* control_sd + control_mean) + Z:* (u_1 :* (treatment_sd + treatment_mean + treatment_sd * treatment_mean)))"

```

Another limitation of the current version--from the user standpoint--is that estimation is done in `MATA`. Since in the `R` example, OLS estimates a linear model with one regressor, I simply take the matrices for `Y` and `Z` and wrote `MATA` code corresponding to $\bf(X'X)^{-1}X'y$. This approach is more computationally efficient and this approach may be desirable for (closed form) estimators which come up frequently. However, most users will want to take advantage of `STATA` estimation routines. Is this possible? Yes. One can create `STATA variables` from `MATA`. Therefore one may generate **y** and **z**, add them (with `st_addvar` and `st_store`), and then run a regression with e.g. `reg y z x1 x2 x3` where `x1`, `x2`, and `x3` are loaded into memory by the user in `STATA`. Since `MATA` can execute `STATA` commands, the design could be initialized with something like `two_arm_designer`. Everything else would remain the same except the user would need to pass a string. Something like:
```STATA
two_arm_estimator a   # not run
mata: a.estimator = "reg y z x1 x2 x3"
```
or
```STATA
local e = "reg y z x1 x2 x3" # not run
two_arm_estimator a
declare_estimator a e        # use of locals like this possible but not recommended by MATA conventional wisdom
```
Apart from familiarity, the advantage of this approach would be that it would allow users to define the population (in the sense of saying which types of cases should be dropped) and choose options like robust standard errors, etc. One challenge to this route: `STATA` returns estimates with `E()`. If coefficient names are not standard (or worse if the structure of the `E()` is not standard) across estimators, it will be difficult to code around from the `MATA` side. It may require the user to know coding details one typically wouldn't.

A related, but less ambitious, approach would be to allow the user to import `STATA` variables as covariates. 


# Assessment

One question is whether the key features of `DeclareDesign` are possible in `STATA`. Many are (though a full-fledged 'grammar' of research design is hard to see). 

Another question is whether it would be 'worth' the typical user's time to learn. In Bayesian MCMC, `JAGS` and `STAN` exist independently of user interfaces like `R` and `Python`. Most consider them to have a steep learning curve but many advanced users consider it to be 'worth it' in part because these are highly flexible, versatile systems with robust code bases. For `STATA` to go beyond it's existing suite of research design functions, the user interface would likely require the equivalent of `R` formula objects. But for the amount of effort for the user to learn those commands, they may be better off `R`, which is portable and has a large base of existing online documentation. Or, DeclareDesign may have to make a GUI guide users throuh the input (and which would write some of the more advanced code for replicability).

A middle ground option would be to build out things like `two_arm_designer` for common designs, estimators, etc. These estimators would require a bit of MATA-style input, do most of the estimation in `MATA`, and so be fast but not have the full customizibility of the `R` version.