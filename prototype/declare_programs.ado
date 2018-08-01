/* input sample size */
/* likely will have separate declare_existing_population */

capture program drop declare_population
program define declare_population   
  clear                             
  set obs `1'
  range id 1 `1'
  putmata id, replace
  mata: st_view(id = ., ., "id")
  mata: declared = design()     /* initialize object, will exist after program ends */
  mata: N = rows(id)
  mata: declared.n = N
  mata: declared.id = declared.pop()
  display "Population declared; design initialized with id variable (but not other elements)."
end

/* input number of treated units m */

capture program drop declare_assignment
program define declare_assignment
  mata: declared.m = `1'
  mata: declared.treatment = declared.assign()
  mata: colnum = st_addvar("double", "treatment")
  mata: st_store(., colnum, declared.treatment)
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


  