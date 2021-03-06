capture program drop diagnose
program define diagnose
  display ""
  display "Starting diagnosis..."
  display ""
  mata: stata("set seed " + strofreal(`1'.seed))
  mata: "seed set to " + strofreal(`1'.seed)
  display ""
  mata: `1'.pop()
  mata: `1'.assign()
  mata: `1'.PO()
  mata: `1'.estimand()
  mata: `1'.Estimator()
  mata: "Research design diagnosis based on " + strofreal(`1'.N_sims) + " simulations. Diagnosand estimates:"
  display ""
  mata: "Design label: " + `1'.design_type
  mata: "Estimand label: " + `1'.estimand
  mata: "Estimator label: " + `1'.estimator
  mata: "N sims: " + strofreal(`1'.N_sims) 
  mata: "Bias: " + strofreal(`1'.bias)
  mata: "Mean Estimate: " + strofreal(`1'.Mean_Estimate)
  mata: "SD Estimate: " + strofreal(`1'.SD_Estimate)
  mata: "Mean estimand: " + strofreal(`1'.Mean_Estimand)
  mata: "Type S error rate: " + strofreal(`1'.Type_S_Rate)
  display ""
  display "All estimates may accessed as follows:"
  display "   mata: `1'.Mean_Estimate"
  display "   mata: `1'.Type_S_Rate"
end