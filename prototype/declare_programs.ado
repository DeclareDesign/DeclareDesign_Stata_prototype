/* input sample size */
/* likely will have separate declare_existing_population */

capture program drop declare_design
program define declare_design
  mata: declared = design()
  mata: declared.name = "`1'"
  display "New design declared:"
  mata: declared.name
  display ""
  display "Here are some commands:"
  display "declare_population 100"
  display "Note: above command is not executed until runtime (e.g. simulation). The command will:"
  display "set obs 100"
//  local nuissance  `"declare_existing_population "set obs 100""'
//  display `"`nuissance'"'
  
end

program define bonjour
  display "`1'"
end

capture program drop declare_population
program define declare_population 
  mata: declared.initialize = "`1'"
  display: "On execution, a population will be initialized with the following command:"
  mata: declared.initialize
end


/* input number of treated units m */

capture program drop declare_assignment
program define declare_assignment
  mata: declared.m = `1'
  mata: declared.z = declared.assign()
  mata: colnum = st_addvar("double", "treatment")
  mata: st_store(., colnum, declared.z)
  display: "Assignment declared; design now contains treatment status."
end

capture program drop declare_potential_outcomes
program define declare_potential_outcomes
  mata: declared.distribution = "`1'"
  mata: declared.param1 = `2'
  mata: declared.param2 = `3'
  mata: declared.delta = `4'
  display "Potential outcomes declared; design now contains Y's distribution as well parameters for Y_Z_1 and Y_Z_0."
end  

capture program drop declare_estimand
program define declare_estimand
  mata: declared.estimand = `1'
  display: "Estimand declared."
end

capture program drop declare_estimator
program define declare_estimator
  mata: declared.estimand = `1'
end

estimator reg, VCE; regular variable generation; estimation
save instatianted decarlared object
summary from mata side (print object)
fix ATE for Y_Z_0

clear two arm, diagnosis; all 

estimators, subsetting ...

different steps, different orders

build step

another level, step1, step2, step3... 


  