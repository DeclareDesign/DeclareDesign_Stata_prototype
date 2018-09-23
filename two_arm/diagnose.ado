capture program drop diagnose
program define diagnose
  mata: cmd = "mata: " + "`1'" + ".diagnose()"
  display "Starting diagnosis..."
  display ""
  mata: stata(cmd)
end
