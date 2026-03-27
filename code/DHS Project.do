*Set Working Directory
cd "/Users/pc/Documents/DHS"
*Load 2008 data
use /Users/pc/Downloads/NGIR53FL.DTA, clear
gen survey_year = 2008
save "dhs2008.dta", replace
*load 2013 data
use "/Users/pc/Downloads/NGIR6AFL.DTA", clear
gen survey_year = 2013
save "dhs2013.dta", replace
* Load 2018 data
use "/Users/pc/Downloads/NGIR7AFL.DTA", clear
gen survey_year = 2018
save "dhs2018.dta", replace

*Merge all 3 datasets
use "dhs2008.dta", clear
append using "dhs2013.dta"
append using "dhs2018.dta"

save "nigeria_dhs_merged.dta", replace

*Keep relevant variables
use "nigeria_dhs_merged.dta", clear

keep v001 v022 v024 v005 v012 v106 v190 v025 sstate v743a v743b v743d survey_year

save "nigeria_dhs_clean.dta", replace

*Creating Autonomy Index
use "nigeria_dhs_clean.dta", clear

* Recode autonomy variables
foreach var in v743a v743b v743d {
    gen `var'_aut = .
    replace `var'_aut = 1 if inlist(`var', 1, 2, 3)
    replace `var'_aut = 0 if inlist(`var', 4, 5, 6)
}

* Create an average autonomy index
egen autonomy_index = rowmean(v743a_aut v743b_aut v743d_aut)

label var autonomy_index "Mean autonomy index (3 decisions)"

*Identify Treatment & Control States
decode sstate, gen(state_name)
tab state_name
gen treat = 0
replace treat = 1 if inlist(state_name, "anambra", "bauchi", "kaduna", "niger", "ondo", "zamfara")

label var treat "1 = SURE-P treated state, 0 = control"
tab state_name treat

*Create post-treatment Dummies
gen post2013 = (survey_year == 2013)
gen post2018 = (survey_year == 2018)

label var post2013 "Post 2013 period"
label var post2018 "Post 2018 period"

tab survey_year post2013
tab survey_year post2018

*Create a dummy variable for Urban Areas
gen urban = (v025 == 1)
label var urban "Urban residence (1=urban)"

*Label Variables
label var v012  "Respondent age"
label var v106  "Education level"
label var v190  "Wealth index"
label var v025  "Urban (1) / Rural (2)"
label var autonomy_index "Mean autonomy index (3 decisions)"

*Save Dataset
save "nigeria_dhs_analysis.dta", replace

*Analysis
* Apply sampling weight
gen weight = v005 / 1000000

use "nigeria_dhs_analysis.dta", clear

gen weight = v005/1000000
*Descriptive summary
tabstat autonomy_index v012 v106 v190 urban [aw=weight], by(survey_year) stat(mean sd n)
asdoc summarize autonomy_index v012 v106 v190 urban [aw=weight], by(survey_year) dec(2) replace 
*Baseline Balance Table
asdoc tabstat autonomy_index v012 v106 v190 urban [aw=weight] if survey_year==2008, by(treat) stat(N sd mean) dec(2) 

*Two-way means
collapse (mean) autonomy_index [aw=weight], by(treat survey_year)
list, sepby(treat)

separate autonomy_index, by(treat)
gen weight = v005/1000000
collapse (mean) autonomy_index [aw=weight], by(treat survey_year)
twoway (connected autonomy_index survey_year if treat==1, sort msymbol(circle) lcolor(blue) lpattern(solid)) ///
       (connected autonomy_index survey_year if treat==0, sort msymbol(triangle) lcolor(red) lpattern(dash)), ///
       legend(order(1 "Treated (SURE-P)" 2 "Control")) ///
       ytitle("Mean Autonomy Index") xtitle("Survey Year") ///
       title("Trends in Women's Autonomy: Treated vs Control States") ///
       graphregion(color(white))

*Regression
*Baseline Difference-in-Differences Regression (without controls) (and with controls + fixed effects)
use "nigeria_dhs_analysis.dta", clear
gen weight = v005/1000000
reg autonomy_index i.treat##i.post2013 i.treat##i.post2018 [aw=v005], robust
est store model1
reg autonomy_index i.treat##i.post2013 i.treat##i.post2018 v012 v106 v190 urban i.v024 i.survey_year [aw=v005], robust
est store model2
outreg2 [model1 model2] using "regression_results.doc", replace dec(4) se bracket r2 adjr2 addstat(F-statistic, e(F), Observations, e(N)) title("Impact of CCT (SURE-P) on Women's Autonomy") ctitle("Baseline" "Controlled") addnote("Robust standard errors in parentheses. * p<0.10, ** p<0.05, *** p<0.01")
********************


ssc install estout, replace
eststo clear
eststo: reg autonomy_index i.treat##i.post2013 i.treat##i.post2018 [aw=weight]
esttab using "Table4_DiD.rtf", replace se label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
title("Table 4. Baseline Difference-in-Differences Regression: SURE-P and Women's Autonomy") ///
addnotes("Weighted by DHS sampling weights. Standard errors in parentheses.")

*Difference-in-Differences with controls + fixed effects
reg autonomy_index i.treat##i.post2013 i.treat##i.post2018 v012 v106 v190 urban i.v024 i.survey_year [aw=v005], robust

eststo clear
eststo: reg autonomy_index i.treat##i.post2013 i.treat##i.post2018 v012 v106 v190 urban i.v024 i.survey_year [aw=v005], robust
esttab using "Table5_Controlled_DiD.rtf", replace se label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
title("Table 5. Difference-in-Differences Regression with Controls and Fixed Effects") ///
addnotes("Weighted by DHS sampling weights. Region and year fixed effects included. Robust SEs in parentheses.")

asdoc reg autonomy_index i.treat##i.post2013 i.treat##i.post2018 v012 v106 v190 urban i.v024 i.survey_year [aw=v005], robust





