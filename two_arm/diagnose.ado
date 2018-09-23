capture program drop diagnose
program define diagnose
  display "Starting diagnosis..."
  display ""
  mata: `1'.diagnose()
end