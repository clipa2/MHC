/* 
Purpose: Regressions for Crime per 10,000
*/

*** GENERAL COURT ON CRIME

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

preserve
	**Total Crime Rate
	xtreg total_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust

	eststo _reg1 
	
	gen dummy = 1
	reg total_crime_rate dummy if court == 0 & year_court_estab > 0, nocons robust
	eststo _reg1a

restore
preserve

	**Violent Crime Rate
	xtreg violent_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust

	eststo _reg2
		
	gen dummy = 1
	reg violent_crime_rate dummy if court == 0 & year_court_estab > 0, nocons robust
	eststo _reg2a

restore
preserve

	**Property Crime Rate
	xtreg property_crime_rate court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_code i.year, fe robust
	eststo _reg3
	
	gen dummy = 1
	reg property_crime_rate dummy if court == 0 & year_court_estab > 0, nocons robust
	eststo _reg3a

restore
	
esttab _reg1a _reg2a _reg3a using "${overleaf}/results/general_reg.tex", replace ///
	cells("b(fmt(a2) pattern(1 1 1))")  ///
	varlabels(dummy "Mean") ///
	mtitles("Total Crime" "Violent Crime" "Property Crime") ///
	posthead("\hline") ///
	collabels(none) nonotes nodepvars nolines nonum nogaps booktabs noobs nostar f

esttab _reg1 _reg2 _reg3 using "${overleaf}/results/general_reg.tex", append ///
		keep(court) se(%9.0g) varlabels(court "County Established MHC") ///
		star(* .10 ** .05 *** .01) ///
		collabels(none) nodepvars nonum nomtitle ///
		nonotes nolines booktabs f	
