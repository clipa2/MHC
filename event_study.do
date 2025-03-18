/* 

Purpose: Create Event Study Graphs

*/
********************************************************************************
****Total Crime Rate
use "crime_data.dta", clear

tostring(county_code), replace
tostring(state_code), replace
gen county_state_code = county_code + state_code
replace county_state_code = "20021" if county_code == "2" & state_code == "21"
replace county_state_code = "20015" if county_code == "2" & state_code == "15"
replace county_state_code = "10043" if county_code == "1" & state_code == "43"
replace county_state_code = "10013" if county_code == "1" & state_code == "13"
destring(county_state_code), replace
destring(state_code), replace
destring(county_code), replace

drop state county
xtset county_state_code

* create the lag/lead for treated states
* fill in control obs with 0
* This allows for the interaction between `treat` and `time_to_treat` to occur for each state.
* Otherwise, there may be some NAs and the estimations will be off.
g time_to_treat = year - year_court_estab
replace time_to_treat = 0 if year_court_estab == 0
replace time_to_treat = 9 if time_to_treat > 8
keep if time_to_treat <= 9 & time_to_treat > -10

* this will determine the difference
* between controls and treated states
g treat = year_court_estab > 0 & year > year_court_estab

* Stata won't allow factors with negative values, so let's shift
* time-to-treat to start at 0, keeping track of where the true -1 is
summ time_to_treat
g shifted_ttt = time_to_treat - r(min)
summ shifted_ttt if time_to_treat == -1
local true_neg1 = r(mean)

* Regress on our interaction terms with FEs for group and year,
* clustering at the group (state) level
* use ib# to specify our reference group
xtreg total_crime_rate ib`true_neg1'.shifted_ttt average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust

*Now we can plot.

* Pull out the coefficients and SEs
g coef = .
g se = .
levelsof shifted_ttt, l(times)
foreach t in `times' {
	replace coef = _b[`t'.shifted_ttt] if shifted_ttt == `t'
	replace se = _se[`t'.shifted_ttt] if shifted_ttt == `t'
}

* Make confidence intervals
g ci_top = coef+1.96*se
g ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per quarter
* now switch back to time_to_treat to get original timing
keep time_to_treat coef se ci_*
duplicates drop

sort time_to_treat

* Create connected scatterplot of coefficients
* with CIs included with rcap
* and a line at 0 both horizontally and vertically
summ ci_top
local top_range = r(max)
summ ci_bottom
local bottom_range = r(min)

twoway (sc coef time_to_treat, connect(line) leg(off)) ///
	(rcap ci_top ci_bottom time_to_treat, leg(off)) ///
	(function y = 0, range(time_to_treat) leg(off)) ///
	(function y = 0, range(`bottom_range' `top_range') leg(off) horiz), ///
	xtitle("Time to Treatment") title("Event Study: Total Crime") caption("95% Confidence Intervals Shown") 
	
graph export "${overleaf}/local_event_study/total_crime.png", replace
	
	
********************************************************************************
****Violent Crime Rate
use "crime_data.dta", clear

tostring(county_code), replace
tostring(state_code), replace
gen county_state_code = county_code + state_code
destring(county_state_code), replace
destring(state_code), replace
destring(county_code), replace

drop state county
xtset county_state_code


* create the lag/lead for treated states
* fill in control obs with 0
* This allows for the interaction between `treat` and `time_to_treat` to occur for each state.
* Otherwise, there may be some NAs and the estimations will be off.
g time_to_treat = year - year_court_estab
replace time_to_treat = 0 if year_court_estab == 0
replace time_to_treat = 9 if time_to_treat > 8
keep if time_to_treat <= 9 & time_to_treat > -10

* this will determine the difference
* btw controls and treated states
g treat = year_court_estab > 0 & year > year_court_estab

* Stata won't allow factors with negative values, so let's shift
* time-to-treat to start at 0, keeping track of where the true -1 is
summ time_to_treat
g shifted_ttt = time_to_treat - r(min)
summ shifted_ttt if time_to_treat == -1
local true_neg1 = r(mean)

* Regress on our interaction terms with FEs for group and year,
* clustering at the group (state) level
* use ib# to specify our reference group
xtreg violent_crime_rate ib`true_neg1'.shifted_ttt average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust

*Now we can plot.

* Pull out the coefficients and SEs
g coef = .
g se = .
levelsof shifted_ttt, l(times)
foreach t in `times' {
	replace coef = _b[`t'.shifted_ttt] if shifted_ttt == `t'
	replace se = _se[`t'.shifted_ttt] if shifted_ttt == `t'
}

* Make confidence intervals
g ci_top = coef+1.96*se
g ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per quarter
* now switch back to time_to_treat to get original timing
keep time_to_treat coef se ci_*
duplicates drop

sort time_to_treat

* Create connected scatterplot of coefficients
* with CIs included with rcap
* and a line at 0 both horizontally and vertically
summ ci_top
local top_range = r(max)
summ ci_bottom
local bottom_range = r(min)

twoway (sc coef time_to_treat, connect(line) leg(off)) ///
	(rcap ci_top ci_bottom time_to_treat, leg(off)) ///
	(function y = 0, range(time_to_treat) leg(off)) ///
	(function y = 0, range(`bottom_range' `top_range') leg(off) horiz), ///
	xtitle("Time to Treatment") title("Event Study: Violent Crime") caption("95% Confidence Intervals Shown")

graph export "${overleaf}/local_event_study/violent_crime.png", replace

	
********************************************************************************
****Property Crime Rate
use "crime_data.dta", clear


tostring(county_code), replace
tostring(state_code), replace
gen county_state_code = county_code + state_code
destring(county_state_code), replace
destring(state_code), replace
destring(county_code), replace

drop state county
xtset county_state_code


* create the lag/lead for treated states
* fill in control obs with 0
* This allows for the interaction between `treat` and `time_to_treat` to occur for each state.
* Otherwise, there may be some NAs and the estimations will be off.
g time_to_treat = year - year_court_estab
replace time_to_treat = 0 if year_court_estab == 0
replace time_to_treat = 9 if time_to_treat > 8
keep if time_to_treat <= 9 & time_to_treat > -10

* this will determine the difference
* btw controls and treated states
g treat = year_court_estab > 0 & year > year_court_estab

* Stata won't allow factors with negative values, so let's shift
* time-to-treat to start at 0, keeping track of where the true -1 is
summ time_to_treat
g shifted_ttt = time_to_treat - r(min)
summ shifted_ttt if time_to_treat == -1
local true_neg1 = r(mean)

* Regress on our interaction terms with FEs for group and year,
* clustering at the group (state) level
* use ib# to specify our reference group
xtreg property_crime_rate ib`true_neg1'.shifted_ttt average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust

*Now we can plot.

* Pull out the coefficients and SEs
g coef = .
g se = .
levelsof shifted_ttt, l(times)
foreach t in `times' {
	replace coef = _b[`t'.shifted_ttt] if shifted_ttt == `t'
	replace se = _se[`t'.shifted_ttt] if shifted_ttt == `t'
}

* Make confidence intervals
g ci_top = coef+1.96*se
g ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per quarter
* now switch back to time_to_treat to get original timing
keep time_to_treat coef se ci_*
duplicates drop

sort time_to_treat

* Create connected scatterplot of coefficients
* with CIs included with rcap
* and a line at 0 both horizontally and vertically
summ ci_top
local top_range = r(max)
summ ci_bottom
local bottom_range = r(min)

twoway (sc coef time_to_treat, connect(line) leg(off)) ///
	(rcap ci_top ci_bottom time_to_treat, leg(off)) ///
	(function y = 0, range(time_to_treat) leg(off)) ///
	(function y = 0, range(`bottom_range' `top_range') leg(off) horiz), ///
	xtitle("Time to Treatment") title("Event Study: Property Crime") caption("95% Confidence Intervals Shown")


graph export "${overleaf}/local_event_study/property_crime.png", replace

********************************************************************************
****Homelessness
use "homelessness_data.dta", clear
gen id = _n

bys county county_fips: replace id = id[_n-1] if county[_n] == county[_n-1] & county_fips[_n] == county_fips[_n-1]
xtset id

gen state_num = _n
bys state: replace state_num = state_num[_n-1] if state[_n] == state[_n-1]

* create the lag/lead for treated states
* fill in control obs with 0
* This allows for the interaction between `treat` and `time_to_treat` to occur for each state.
* Otherwise, there may be some NAs and the estimations will be off.
g time_to_treat = year - year_court_estab
replace time_to_treat = 0 if year_court_estab == 0
replace time_to_treat = 9 if time_to_treat > 8
keep if time_to_treat <= 9 & time_to_treat > -10
* this will determine the difference
* btw controls and treated states
g treat = year_court_estab > 0 & year > year_court_estab

* Stata won't allow factors with negative values, so let's shift
* time-to-treat to start at 0, keeping track of where the true -1 is
summ time_to_treat
g shifted_ttt = time_to_treat - r(min)
summ shifted_ttt if time_to_treat == -1
local true_neg1 = r(mean)

* Regress on our interaction terms with FEs for group and year,
* clustering at the group (state) level
* use ib# to specify our reference group
	xtreg percent_homeless ib`true_neg1'.shifted_ttt average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust

*Now we can plot.

* Pull out the coefficients and SEs
g coef = .
g se = .
levelsof shifted_ttt, l(times)
foreach t in `times' {
	replace coef = _b[`t'.shifted_ttt] if shifted_ttt == `t'
	replace se = _se[`t'.shifted_ttt] if shifted_ttt == `t'
}

* Make confidence intervals
g ci_top = coef+1.96*se
g ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per quarter
* now switch back to time_to_treat to get original timing
keep time_to_treat coef se ci_*
duplicates drop

sort time_to_treat

* Create connected scatterplot of coefficients
* with CIs included with rcap
* and a line at 0 both horizontally and vertically
summ ci_top
local top_range = r(max)
summ ci_bottom
local bottom_range = r(min)

twoway (sc coef time_to_treat, connect(line) leg(off)) ///
	(rcap ci_top ci_bottom time_to_treat, leg(off)) ///
	(function y = 0, range(time_to_treat) leg(off)) ///
	(function y = 0, range(`bottom_range' `top_range') leg(off) horiz), ///
	xtitle("Time to Treatment") title("Event Study: Homelessness") caption("95% Confidence Intervals Shown")


graph export "${overleaf}/local_event_study/homelessness.png", replace


