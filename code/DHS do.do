use "/Users/pc/Downloads/NGIR53FL.DTA"
clear
use "/Users/pc/Downloads/Causal Project/NGIR53FL.DTA", clear
gen survey_year = 2008
tempfile ir2008
save `ir2008'
use "/Users/pc/Downloads/Causal Project/NGIR6AFL.DTA", clear
gen survey_year = 2013
tempfile ir2013
save `ir2013'
use "/Users/pc/Downloads/Causal Project/NGIR7AFL.DTA", clear
set maxvar
about
set maxvar 32767
use "/Users/pc/Downloads/Causal Project/NGIR7AFL.DTA", clear
gen survey_year = 2018
tempfile ir2018
save `ir2018'
use `ir2013', clear
append using `ir2008'
append using `ir2018'
lookfor v743a v743b v743c v743d
recode v743a (1 3=1) (2 4 5=0) (else=.), gen(auto_health)
recode v743b (1 3=1) (2 4 5=0) (else=.), gen(auto_purchase)
recode v743c (1 3=1) (2 4 5=0) (else=.), gen(auto_daily needs)
recode v743d (1 3=1) (2 4 5=0) (else=.), gen(auto_visits)
recode v743c (1 3=1) (2 4 5=0) (else=.), gen(auto_dailyneeds)
egen autonomy_index = rowmean(auto_health auto_purchase auto_dailyneeds auto_visits)
label var autonomy_index "Autonomy index (0-1)"
capture decode v024, gen (region)
sum region
sum v024
if _rc!=0 tostring v024, gen (region) force
tab region, missing
capture decode sstate, gen (state)
if _rc!=0 tostring sstate, gen (state) force
tab state, missing
local treat_states "anambra bauchi kaduna niger ondo zamfara"
gen byte treat = 0
foreach s of local treat_states {
 replace treat = 1 if state == "`s'"
}
label var treat "SURE-P state (treated)"
tab treat
tab SURE-P state (treated)
tab treat_states
tab state treat, m
tab state treat, missing
clonevar edu_level = v106
gen byte urban = (v024==1) if !missing(v024)
clonevar wealth_q = v190
clonevar age = v012
gen agesq = age^2
svy: mean autonomy_index age
svy: tab urban, col
svy: tab edu_level, col
svy: tab wealth_q, col
