capture program drop diagnose
program define diagnose
  mata: stata("set seed " + strofreal(`1'.seed))
  mata: "seed set to " + strofreal(`1'.seed)
  display "Starting diagnosis..."
  display ""
  mata: `1'.pop()
  mata: `1'.assign()
  mata: `1'.PO()
  mata: `1'.diagnose()
  
end