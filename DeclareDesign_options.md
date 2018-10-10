---
title: DeclareDesign options in STATA
author: Pete Mohanty
date: October 10th, 2018
---

This document discusses possibilities and obstacles to implementing `DeclareDesign` in `STATA` in light of two prototypes, both of which are implementations of a simple two-arm design. The first version, hereafter referred to as `SO` (as in, the `STATA-only` version), makes use of `simulate`. The second version, hereafter `MW` (as in, the `MATA-wrapper` version), creates a `class` for `design` objects and also does core calculations in `MATA`. 

### LINKS
[Original R code](https://declaredesign.org/library/articles/simple_two_arm.html)  
[SO: detailed description of STATA-only](https://github.com/DeclareDesign/MATA/blob/master/twoarm_stata_only/STATA-only.md)  
[MW: detailed description of MATA-wrapper](https://github.com/DeclareDesign/MATA/blob/master/two_arm/two_arm.md)  


# Discussion
`MW` comes (or could come) much closer to the corresponding declare `R` packages in terms of functionality. Importantly, `MW` allows users to declare aspects of designs in various sequences without simulating or estimating. `MW` still has serious limits in terms of customizability--in particular, it is not possible to add 'unanticipated' variables to the `design` class in 'interactive' mode. The more important limitation of `MW` is from the standpoint of user-friendliness. Though variables can be initialized with one line of code (and the program prompts users with examples), users unfamiliar with `MATA` or scripting more generally may not have a sense of what's being accomplished.

Of the two, `MW` has the potential to be faster, both because `MATA` is a lower level language and because re-implementing common estimators would give one the opportunity to skip calculations which are superfluous to the design. Those speed savings would be hardwon, however, in terms of time spent coding, and because such optimization may make user input more complicated still.

`SO`, by contrast, is more user friendly. Though `MW` could be adapted to execute `STATA` regression commands, `SO` would do so in a way that's more familar  and less error-prone. (That's because `MATA` executes `STATA` commands as strings which, like `eval(parse())` in `R`, are more difficult to debug than regular code.) `SO` (in particular [twoarmX.ado](https://github.com/DeclareDesign/MATA/blob/master/twoarm_stata_only/twoarmX.ado), which shows how to incorporate covariates from existing data sets) does go beyond existing `STATA` functionality for research design. But `SO` collapses key steps of declaring and diagnosing, limiting the value-added for users with complex or atypical research designs.


