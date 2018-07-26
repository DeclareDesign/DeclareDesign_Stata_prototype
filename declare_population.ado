/* still buggy but shows more complex workflow between ado and MATA */

program define declare_population, eclass sortpreserve
  version 14 
  
  syntax varlist(numeric ts fv) [if] [in] [, noCONStant ]  
  gettoken depvar indepvar : varlist
  /* independent variables may be relevant to subsetting if declaring from pre-existing data */
  marksample touse
  
  /* f for factor */
  _fv_check_depvar `depvar'

  fvexpand `indepvars' 
  /* expand factors a la model.matrix */
  
  local cnames `r(varlist)'
  
  tempname id N

  mata: m_pop("`depvar'", "`cnames'", "`touse'", "`constant'", "`id'", "`N'") 
  
  if "`constant'" == "" {
    	local cnames `cnames' _cons
  }

  ereturn post `id', esample(`touse') buildfvinfo
  ereturn scalar N       = `N'
  ereturn local  cmd     "declare_population"
  /* to do, return column names (can easily depend on sample when factors are present...) */

end

capture mata mata drop m_pop()
version 14
mata:
void m_pop(string scalar depvar,  string scalar indepvars, 
             string scalar touse,   string scalar constant,  
	           string scalar IDname, string scalar Nname)
{
    real vector y, id
    real matrix X
    real scalar n

    y    = st_data(., depvar, touse)
    X    = st_data(., indepvars, touse)
    n    = rows(X)

    if (constant == "") {
        X    = X,J(n,1,1) 
    }
    
    for(i=1; i <= n; i++){
      id[i] = i
    }

    st_matrix(IDname, id)
    st_numscalar(Nname, n)
}

end
