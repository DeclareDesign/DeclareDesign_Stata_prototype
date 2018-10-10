capture program drop twoarmX
program twoarmX, rclass
  version 15
  drop _all
  sysuse auto
  local assignment_prob  =  0.5
  local control_mean  =  0
  local control_sd  =  1
  local treatment_mean  =  1
  local treatment_sd  =  1
  local rho  =  1
  
  gen u_0 = rnormal()
  gen sd1 = sqrt(1 - `rho'^2)
  
  if(sd1 == 0){
    gen u_1 = `rho' * u_0
  }
  else{
    gen u_1 = rnormal(`rho', `sd1')
  }
  
  gen Z = runiform() < `assignment_prob'
  
  gen Y_Z_0 = (1-Z)*(u_0*`control_sd' + `control_mean')
  gen Y_Z_1 = Z*(u_1*`control_sd' + `control_mean')
  gen Y = Z*Y_Z_1 + (1 - Z)*Y_Z_0
  
  gen tau = Y_Z_1 - Y_Z_0
  summarize tau
  return scalar estimand = r(mean)
  
  regress Y Z mpg weight
  local estimate _b[Z]
  return scalar estimate = `estimate'
  
  local se _se[Z]
  return scalar se = `se'
  
  local p 2 * ttail(e(df_r), abs(_b[Z]/_se[Z]))
  return scalar p = `p'
  
  
end
  