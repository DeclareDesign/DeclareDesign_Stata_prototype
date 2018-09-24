capture program drop two_arm_designer
program define two_arm_designer
  mata: `1' = design()
  mata: `1'.name = "`1'"
  mata: `1'.design_type = "two_arm"
  mata: `1'.N = 100
  mata: `1'.N_sims = 500
  mata: `1'.assignment_prob = 0.5
  mata: `1'.control_mean = 0
  mata: `1'.control_sd = 1
  mata: `1'.treatment_mean = 0.5
  mata: `1'.treatment_sd = 1
  mata: `1'.rho = 1
  mata: `1'.estimand = "ATE"
  mata: `1'.seed = ceil(runiform(1, 1, 0, 1000000))
  display ""
  display "New two arm design stored as:"
  mata: `1'.name
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
  display "   estimand (default: 'ATE'),"
  mata: " seed: " + strofreal(`1'.seed)
  display ""
  display "Update parameters as follows:"
  display "   mata: `1'.N = 1000"
  display "   mata: `1'.rho = .4"
  display ""
  display "To make a copy of this design:"
  display "   mata: my_copy = `1'"
  display ""
  display "Finally, to diagnose run the STATA command:"
  display "   diagnose [designname]"
  display "   diagnose `1'"
end
