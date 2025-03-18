/* 

Purpose: Cost Benefit Analysis

*/
********************************************************************************
use "crime_data.dta", clear

// -Main result is the decline in crimes/person = -19.69/10,000.
// -Therefore, Total Crimes Erased = (19.69/10,000)*(County total population across all treated counties for each year summed across years) 

drop if years_since == 0

gen years_of_court = 1

collapse (sum) murder_rate rape_rate robbery_rate aggravated_assault_rate property_crime_rate burglary_rate larceny_rate motor_vehicle_theft_rate arson_rate total_crime_rate years_of_court (max) population approx_annual_enrollment, by(county_code state_code)

gen total_murder_erased = (.027/10000)*population
gen total_rape_erased = (.097/10000)*population
gen total_robbery_erased = (1.25/10000)*population
gen total_assault_erased = (1.35/10000)*population
gen total_burglary_erased = (1.56/10000)*population
gen total_larceny_erased = (9.08/10000)*population
gen total_vehicle_erased = (4.61/10000)*population
//gen total_arson_erased = (-.0338162/10000)*population

// -A = Money saved = (Total Crimes Erased)*(Cost of crime) {I would do this accounting for crime type - instead of 19.69 take the coefficients by type (Figure 9) and multiply by type-specific cost, then sum across types. Don't worry if the coefficient for the type is not statistically significant.}

gen money_saved_murder = total_murder_erased*(7000000)*1.42
gen money_saved_rape = total_rape_erased*(142020)*1.42
gen money_saved_robbery = total_robbery_erased*12624*1.42
gen money_saved_assault = total_assault_erased*38924*1.42
gen money_saved_burglary = total_burglary_erased*2104*1.42
gen money_saved_larceny = total_larceny_erased*473*1.42
gen money_saved_vehicle = total_vehicle_erased*5786*1.42

// gen money_saved_violent = money_saved_murder + money_saved_rape+money_saved_robbery+ money_saved_assault
gen money_saved_violent = money_saved_robbery+money_saved_murder+ money_saved_rape+money_saved_assault
gen money_saved_property = money_saved_larceny+money_saved_vehicle+money_saved_burglary
gen money_saved_total = money_saved_violent+money_saved_property

// -B = Money spent = (Treated population across all treated counties for each year summed across years)*(Average cost per person of MHC treatment instead of jail stay) 

*8059 in 2021 == 10,032.50
gen money_spent = approx_annual_enrollment*9450.44*years_of_court
drop if missing(approx_annual_enrollment) | approx_annual_enrollment == 0

// Is A greater than B? 
gen cost_analysis = money_saved_total - money_spent

tab cost_analysis
//10/112 are negative --> 91.07% of counties are saving costs by developing
