N  <-  100
assignment_prob  <-  0.5
control_mean  <-  0
control_sd  <-  1
treatment_mean  <-  1
treatment_sd  <-  1
rho  <-  1

# M: Model
population <- declare_population(
  N = N,
  u_0 = rnorm(N),
  u_1 = rnorm(n = N, mean = rho * u_0, sd = sqrt(1 - rho^2)))

potential_outcomes <- declare_potential_outcomes(
  Y ~ (1-Z) * (u_0*control_sd + control_mean) + 
    Z     * (u_1*treatment_sd + treatment_mean))

# I: Inquiry
estimand <- declare_estimand(ATE = mean(Y_Z_1 - Y_Z_0))

# D: Data Strategy
assignment <- declare_assignment(prob = assignment_prob)
reveal_Y    <- declare_reveal()

# A: Answer Strategy
estimator <- declare_estimator(Y ~ Z, estimand = estimand)

# Design
simple_two_arm_design <- population + potential_outcomes + estimand + assignment + reveal_Y + estimator

diagnosis <- diagnose_design(simple_two_arm_design)
