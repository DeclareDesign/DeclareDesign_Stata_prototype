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
/* M is inelegant but only stata 'variables' and strings may pass... */

capture program drop declare_assignment
program define declare_assignment
  quietly gen M = `1'                   
  putmata M, replace
  mata: st_view(m = ., ., "M") 
  mata: declared.m = m[1]
  mata: declared.treatment = declared.assign()
  drop M
  mata: colnum = st_addvar("double", "treatment")
  mata: st_store(., colnum, declared.treatment)
  display: "Assignment declared; design now contains treatment status."
end
  