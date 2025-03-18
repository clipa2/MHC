/*

Purpose: Homelessness Regressions

*/

use "homelessness_data.dta", clear

gen id = _n

bys county county_fips: replace id = id[_n-1] if county[_n] == county[_n-1] & county_fips[_n] == county_fips[_n-1]
xtset id

gen state_num = _n
bys state: replace state_num = state_num[_n-1] if state[_n] == state[_n-1]

	**Homelessness
	xtreg percent_homeless court average_age per_capita_income percent_white percent_black percent_male percent_below_pov population i.state_num i.year, fe robust
		
	eststo _reg1 
	
	gen dummy = 1
	reg percent_homeless dummy if court == 0 & year_court_estab > 0 , nocons robust
	eststo _reg1a


esttab _reg1a  using "${overleaf}/results/general_reg_homelessness.tex", replace ///
	cells("b(fmt(a2) pattern(1))")  ///
	varlabels(dummy "Mean") ///
	mtitles("Homelessness Per 10,000") ///
	posthead("\hline") ///
	collabels(none) nonotes nodepvars nolines nonum nogaps booktabs noobs f

esttab _reg1  using "${overleaf}/results/general_reg_homelessness.tex", append ///
		keep(court) se(%9.0g) varlabels(court "County Established MHC") ///
		star(* .10 ** .05 *** .01) ///
		collabels(none) nodepvars nonum nomtitle ///
		nonotes nolines booktabs f	
