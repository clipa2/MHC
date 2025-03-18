/* 

Purpose: Robustness Checks

*/

use "crime_data.dta", clear

tostring(county_code), replace
tostring(state_code), replace
gen county_state_code = county_code + state_code
replace county_state_code = "20021" if county_code == "2" & state_code == "21"
replace county_state_code = "20015" if county_code == "2" & state_code == "15"
replace county_state_code = "10043" if county_code == "1" & state_code == "43"
replace county_state_code = "10013" if county_code == "1" & state_code == "13"
replace unemployment_rate = 4.7 if county_code == "26" & state_code == "19" & missing(unemployment_rate)
replace unemployment_rate = 5.7 if county_code == "36" & state_code == "19" & missing(unemployment_rate)
replace unemployment_rate = 4.2 if county_code == "52" & state_code == "19" & missing(unemployment_rate)
destring(county_state_code), replace
destring(state_code), replace
destring(county_code), replace

drop state county
xtset county_state_code


********************************************************************************
***TOTAL CRIMES
	***Normal (**)
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
	
		estimates store A
		
	***Unweighted (***)
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year
		
		estimates store B
	
	***Exclude state and year fixed-effects (***)
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population, fe robust
	
		estimates store C
		

	***Apply two-way clustering
	
	***No counties with no MHCs (*)
	preserve
	keep if year_court_estab > 0 
	xtreg total_crime_rate  court average_age per_capita_income graduate_hs percent_white unemployment_rate percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store D
	restore
	
	***Without 2014+ (**)
	preserve
	drop if year_court_estab > 2014 
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store F
	restore
	

	***Without population restriction (***)
	preserve
	use "$crime_all_data.dta", clear
	tostring(county_code), replace
	tostring(state_code), replace
	gen county_state_code = county_code + state_code
	replace county_state_code = "20021" if county_code == "2" & state_code == "21"
	replace county_state_code = "20015" if county_code == "2" & state_code == "15"
	replace county_state_code = "10043" if county_code == "1" & state_code == "43"
	replace county_state_code = "10013" if county_code == "1" & state_code == "13"
	replace unemployment_rate = 4.7 if county_code == "26" & state_code == "19" & missing(unemployment_rate)
	replace unemployment_rate = 5.7 if county_code == "36" & state_code == "19" & missing(unemployment_rate)
	replace unemployment_rate = 4.2 if county_code == "52" & state_code == "19" & missing(unemployment_rate)
	destring(county_state_code), replace
	destring(state_code), replace
	destring(county_code), replace

	drop state county
	xtset county_state_code
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store G
	restore
	
	***Aggregate to the state level ()
	preserve
	gen total_crime = (total_crime_rate*population)/10000
	
	collapse (sum) total_crime court population (mean) average_age per_capita_income graduate_hs percent_white percent_black unemployment_rate percent_male percent_below_pov, by (state_code year)
	
	gen total_crime_rate = (total_crime/population)*10000
	
	replace court = 1 if court > 1
	xtset state_code
	
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.year, fe robust
	
	estimates store E
	
	restore

	***Matched by characteristics
	preserve
	import delimited "matched_crime_rates.csv", clear
	xtset county_state_code
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
	estimates store H
	restore


**** MAKE PLOT
label variable court " "
	
coefplot (A, asequation(Main Estimate**) \ ///
		 C, asequation(Excluding State and Year Fixed-Effects***)  \ ///
		 D, asequation(Counties with MHCs 2014+ as Control*)  \ ///
		 F, asequation(Excluding Counties with MHCs 2014+ as Control**)  \ ///
		 G, asequation(Without Population Restriction***)  \ ///
		 E, asequation(Aggregate to State Level)  \ ///
		 H, asequation(Matched by Characteristics***) \ ///
    , keep(court) drop(_cons) xline(0) title("Robustness Check: Total Crime") ///
	ciopts(color(green)) mcolor(green)

graph export "$robustness/total_crime_robustness.png", replace

	
	
	
********************************************************************************
***VIOLENT CRIMES

	***Normal (**)
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		
	estimates store A
	
	***Unweighted (***)
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe
	
	estimates store B
	
	***Exclude state and year fixed-effects (***)
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population, fe robust
	
	estimates store C

	***Apply two-way clustering
	
	***No counties with no MHCs
	preserve
	keep if year_court_estab > 0 
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store D
	restore
	
	***Without 2014+ (**)
	preserve
	drop if year_court_estab > 2014 
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store F
	restore
	
	
	***Without population restriction (***)
	preserve
	use "crime_all_data.dta", clear
	tostring(county_code), replace
	tostring(state_code), replace
	gen county_state_code = county_code + state_code
	replace county_state_code = "20021" if county_code == "2" & state_code == "21"
	replace county_state_code = "20015" if county_code == "2" & state_code == "15"
	replace county_state_code = "10043" if county_code == "1" & state_code == "43"
	replace county_state_code = "10013" if county_code == "1" & state_code == "13"
	replace unemployment_rate = 4.7 if county_code == "26" & state_code == "19" & missing(unemployment_rate)
	replace unemployment_rate = 5.7 if county_code == "36" & state_code == "19" & missing(unemployment_rate)
	replace unemployment_rate = 4.2 if county_code == "52" & state_code == "19" & missing(unemployment_rate)
	destring(county_state_code), replace
	destring(state_code), replace
	destring(county_code), replace

	drop state county
	xtset county_state_code
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store G
	restore
	
	***Aggregate to the state level ()
	preserve
	gen violent_crime = (violent_crime_rate*population)/10000
	
	collapse (sum) violent_crime court population (mean) unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income, by (state_code year)
	
	gen violent_crime_rate = (violent_crime/population)*10000
	
	replace court = 1 if court > 1
	xtset state_code
	
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.year, fe robust
	
	estimates store E
	
	restore
	
	***Matched by characteristics
	preserve
	import delimited "matched_crime_rates.csv", clear
	xtset county_state_code
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
	estimates store H
	restore

**** MAKE PLOT
label variable court " "

coefplot (A, asequation(Main Estimate**) \ ///
		 C, asequation(Excluding State and Year Fixed-Effects***)  \ ///
		 D, asequation(Counties with MHCs 2014+ as Control)  \ ///
		 F, asequation(Excluding Counties with MHCs 2014+ as Control**)  \ ///
		 G, asequation(Without Population Restriction***)  \ ///
		 E, asequation(Aggregate to State Level)  \ ///
		 H, asequation(Matched by Characteristics***) \ ///
    , keep(court) drop(_cons) xline(0) title("Robustness Check: Violent Crime") ///
	ciopts(color(green)) mcolor(green)

graph export "$robustness/violent_crime_robustness.png", replace


********************************************************************************
***PROPERTY CRIMES

	***Normal (**)
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
	
	estimates store A
		
		
	***Unweighted (***)
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe
	
	estimates store B
	
	***Exclude state and year fixed-effects (***)
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population, fe robust
	
	estimates store C

	***Apply two-way clustering
	
	***No counties with no MHCs (*)
	preserve
	keep if year_court_estab > 0 
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store D
	restore
	
	***Without 2014+ (**)
	preserve
	drop if year_court_estab > 2014 
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store F
	restore
	
	***Without population restriction (***)
	preserve
	use "crime_all_data.dta", clear
	tostring(county_code), replace
	tostring(state_code), replace
	gen county_state_code = county_code + state_code
	replace county_state_code = "20021" if county_code == "2" & state_code == "21"
	replace county_state_code = "20015" if county_code == "2" & state_code == "15"
	replace county_state_code = "10043" if county_code == "1" & state_code == "43"
	replace county_state_code = "10013" if county_code == "1" & state_code == "13"
	replace unemployment_rate = 4.7 if county_code == "26" & state_code == "19" & missing(unemployment_rate)
	replace unemployment_rate = 5.7 if county_code == "36" & state_code == "19" & missing(unemployment_rate)
	replace unemployment_rate = 4.2 if county_code == "52" & state_code == "19" & missing(unemployment_rate)
	destring(county_state_code), replace
	destring(state_code), replace
	destring(county_code), replace

	drop state county
	xtset county_state_code
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
		estimates store G
	restore
	
	***Aggregate to the state level ()
	preserve
	gen property_crime = (property_crime_rate*population)/10000
	
	collapse (sum) property_crime court population (mean) unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income, by (state_code year)
	
	gen property_crime_rate = (property_crime/population)*10000
	
	replace court = 1 if court > 1
	xtset state_code
	
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.year, fe robust
	
	estimates store E
	
	restore
	
	***Matched by characteristics
	preserve
	import delimited "matched_crime_rates.csv", clear
	xtset county_state_code
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
	estimates store H
	restore
	

**** MAKE PLOT

label variable court " "

coefplot (A, asequation(Main Estimate*) \ ///
		 C, asequation(Excluding State and Year Fixed-Effects***)  \ ///
		 D, asequation(Counties with MHCs 2014+ as Control*)  \ ///
		 F, asequation(Excluding Counties with MHCs 2014+ as Control**)  \ ///
		 G, asequation(Without Population Restriction***)  \ ///
		 E, asequation(Aggregate to State Level)  \ ///
		 H, asequation(Matched by Characteristics***) \ //
    , keep(court) drop(_cons) xline(0) title("Robustness Check: Property Crime") ///
	ciopts(color(green)) mcolor(green)

graph export "$robustness/property_crime_robustness.png", replace


********************************************************************************
***Homelessness
use "homelessness_dta.dta", clear
gen id = _n
bys county county_fips: replace id = id[_n-1] if county[_n] == county[_n-1] & county_fips[_n] == county_fips[_n-1]
xtset id
gen state_num = _n
bys state: replace state_num = state_num[_n-1] if state[_n] == state[_n-1]



***TOTAL CRIMES
	***Normal
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe robust
	
		estimates store A
		
	***Unweighted (*)
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe
		
		estimates store B
	
	***Exclude state and year fixed-effects
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population, fe robust
	
		estimates store C
		

	***Apply two-way clustering
	
	***No counties with no MHCs
	preserve
	keep if year_court_estab > 0 
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe robust
		estimates store D
	restore
	
	***Without 2014+
	preserve
	keep if year_court_estab > 2014 
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe robust
		estimates store F
	restore
	
	***Without population restriction (**)
	preserve
	use "homelessness_all_data.dta", clear
	gen id = _n
bys county county_fips: replace id = id[_n-1] if county[_n] == county[_n-1] & county_fips[_n] == county_fips[_n-1]
xtset id
gen state_num = _n
bys state: replace state_num = state_num[_n-1] if state[_n] == state[_n-1]


	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe robust
		estimates store G
	restore
	*/
	
	***Aggregate to the state level ()
	preserve
	
	gen homeless = (percent_homeless*population)/10000
	
	collapse (sum) homeless court population (mean) unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income, by (state_num year)
	
	gen percent_homeless = (homeless/population)*10000
	
	replace court = 1 if court > 1
	xtset state_num
	
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.year, fe robust
	
	estimates store E
	
	restore

		
	***Matched by characteristics
	preserve
	import delimited "matched_homelessness.csv", clear
	gen id = _n
bys county county_fips: replace id = id[_n-1] if county[_n] == county[_n-1] & county_fips[_n] == county_fips[_n-1]
xtset id
gen state_num = _n
bys state: replace state_num = state_num[_n-1] if state[_n] == state[_n-1]

	xtset county_state_code
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe robust
	estimates store H
	restore


**** MAKE PLOT
label variable court " "

coefplot (A, asequation(Main Estimate) \ ///
		 C, asequation(Excluding State and Year Fixed-Effects)  \ ///
		 D, asequation(Counties with MHCs 2014+ as Control)  \ ///
		 F, asequation(Excluding Counties with MHCs 2014+ as Control)  \ ///
		 G, asequation(Without Population Restriction**)  \ ///
		 E, asequation(Aggregate to State Level)  \ ///
		 H, asequation(Matched by Characteristics***) \ /
    , keep(court) drop(_cons) xline(0) title("Robustness Check: Homelessness") ///
	ciopts(color(green)) mcolor(green)

graph export "$robustness/homelessness_robustness.png", replace
