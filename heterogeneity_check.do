/* 

Purpose: Heterogeneity Checks

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
***Specific type of crime
	**Murder rates
	xtreg murder_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store A
	
	mean(murder_rate)  if court == 0 & year_court_estab > 0 
	
	**Rape
	xtreg rape_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store B
	
	mean(rape_rate)  if court == 0 & year_court_estab > 0 
	
	**Robbery
	xtreg robbery_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store C
	
	mean(robbery_rate)  if court == 0 & year_court_estab > 0 

	**Aggravated assaults
	xtreg aggravated_assault_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store D
	
	mean(aggravated_assault_rate)  if court == 0 & year_court_estab > 0 
	
	**Burglaries
	xtreg burglary_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store E
	
	mean(burglary_rate)  if court == 0 & year_court_estab > 0
	
	**Larceny
	xtreg larceny_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store F
	
	mean(larceny_rate)  if court == 0 & year_court_estab > 0

	**Motor vehicle thefts
	xtreg motor_vehicle_theft_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store G
	
	mean(motor_vehicle_theft_rate)  if court == 0 & year_court_estab > 0 
	
	**Arson 
	xtreg arson_rate court unemployment_rate graduate_hs graduate_college death_rate percent_male percent_white percent_black average_age avg_never_married avg_married avg_divorced percent_below_pov per_capita_income population i.state_code i.year, fe robust
	
	estimates store H
	
	mean(arson_rate)  if court == 0 & year_court_estab > 0
	
*** MAKE PLOT
// coefplot A B C D E F G H, keep(court) xline(0) msymbol(S) title("Heterogeneity by Specific Type of Crime") ///
// p1(label(Murder))       ///
// p2(label(Rape))		///
// p3(label(Robbery**))		///
// p4(label(Aggravated Assaults))		///
// p5(label(Burglary*))		///
// p6(label(Larceny*))		///
// p7(label(Motor Vehicle Theft***))		///
// p8(label(Arson))  ///
// drop(_cons) nolabel
label variable court " "


set scheme tab2

coefplot  (I, asequation(Violent Crime*) \ ///
			A, asequation(Murder*) \ ///
         B, asequation(Rape)  \ ///
		 C, asequation(Robbery**)  \ ///
		 D, asequation(Aggravated Assaults)  \ ///
		 J, asequation(Property Crime**) \ ///
		 E, asequation(Burglary)  \ ///
		F, asequation(Larceny*)  \ ///
		G, asequation(Motor Vehicle Theft***)  \ ///
		H, asequation(Arson)  \ ///
          , pstyle(p4)) ///
    , keep(court) drop(_cons) xline(0) title("Heterogeneity by Specific Type of Crime") ///
	ciopts(color(navy) lwidth(thick)) mcolor(navy) scheme(tab2)
	
	
graph export "${overleaf}/heterogeneity/specific_type_of_crime.png", replace
