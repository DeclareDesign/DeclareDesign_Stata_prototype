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
Y := (1 - Z) :* (u_0 :* control_sd + control_mean) + Z:* (u_1 :* treatment_sd + treatment_me
> an))

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

To make a copy of this design:
   mata: my_copy = mydesign

Finally, to diagnose run the STATA command:
   diagnose [designname]
   diagnose mydesign
```
At this point, the `design` object is created and the user can change any of the above mentioned parameters. For example,
```STATA
mydesign.N = 500
```
Once everything is set, to diagnose one simply runs:

```STATA
diagnose mydesign
```


# Customizability vs. User-Friendliness

# Assessment

At this point, I recommend ... 

One question is whether the key features of DeclareDesign are possible in STATA. In general, I believe they are... 

Another question is whether it would be 'worth' the typical user's time to learn. In Bayesian MCMC, `JAGS` and `STAN` exist independently of user interfaces like `R` and `Python`. Most consider them to have a steep learning curve but many advanced users consider it to be 'worth it' in part because these are highly flexible, versatile systems with robust code bases. For `STATA` to go beyond it's existing suite of research design functions, the user interface would likely require the equivalent of `R` formula objects. But for the amount of effort for the user to learn those commands, they may be happier learning some R, which is portable and has a large base of existing online documentation. Or, DeclareDesign may have to make a GUI guide users throuh the input (and which would write some of the more advanced code for replicability).