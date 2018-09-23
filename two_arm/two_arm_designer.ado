capture program drop two_arm_designer
program define two_arm_designer
  mata: declared = design()
  mata: declared.name = "`1'"
  mata: declared.design = "two_arm"
  mata: declared.N = 100
  mata: declared.N_sims = 500
  mata: declared.assignment_prob = 0.5
  mata: declared.control_mean = 0
  mata: declared.control_sd = 1
  mata: declared.treatment_mean = 0.5
  mata: declared.treatment_sd = 1
  mata: declared.rho = 1
  mata: declared.estimand = "ATE"
  display ""
  display "New two arm design stored as 'declared' with declared.name:"
  mata: declared.name
  display "The underlying population is distributed:" 
  display "U_0 ~ Normal(0, 1)"
  display "U_1 ~ Normal(U_0, sqrt(1 - rho^2))"
  display ""
  display "with potential outcomes:"
  display "Y := (1 - Z) :* (u_0 :* control_sd + control_mean) + Z:* (u_1 :* treatment_sd + treatment_mean))"
  display ""
  display "You may wish to alter the following constants:"
  display "   N (default: 100), N_sims (default: 500),"
  display "   assignment_prob (default: 0.5),"
  display "   control_mean (default: 0), control_sd (default: 1),"
  display "   treatment_mean (default: 0.5), treatment_sd (default: 1),"
  display "   rho (default: 1),"
  display "   estimand (default: 'ATE')."
  display ""
  display "Update parameters as follows:"
  display "   mata: declared.N = 1000"
  display "   mata: declared.rho = .4"
  display ""
  display "To make a copy of this design:"
  display "   mata: my_copy = declared"
  display ""
  display "Finally, to diagnose run the STATA command:"
  display "   diagnose [designname]"
  display "   diagnose declared"
  display "   diagnose my_experiment"
end