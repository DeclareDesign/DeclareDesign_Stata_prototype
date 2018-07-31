/* still buggy but shows more complex workflow between ado and MATA */

program define declare_population, eclass sortpreserve

  syntax varlist(numeric fv) [if] [in] [, noCONStant ]  
  gettoken indepvars : varlist
  marksample touse
  
  fvexpand `indepvars' 

  local cnames `r(varlist)'
  
  tempname id N

  mata: m_pop("`cnames'", "`touse'", "`constant'", "`id'", "`N'") 
  
  if "`constant'" == "" {
    	local cnames `cnames' _cons
  }

  ereturn post `id', esample(`touse') buildfvinfo
  ereturn scalar N       = `N'
  ereturn local  cmd     "declare_population"

end

capture mata mata drop m_pop()
mata:
void m_pop(string scalar indepvars, 
             string scalar touse,   string scalar constant,  
	           string scalar IDname, string scalar Nname)
{
    real vector id
    real scalar n

    st_view(y=., depvar, touse)
    n    = length(y)

    for(i=1; i <= n; i++){
      id[i] = i
    }

    st_matrix(IDname, id)
    st_numscalar(Nname, n)
}

end
