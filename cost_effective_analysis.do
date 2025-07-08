/* 
Cost Effectiveness Analysis
*/
********************************************************************************
cd "path" //put paths here
global data_path "data_path" //put paths here

import delimited "$data_path/matched_crime.csv", clear
keep if year > year_court_estab & !missing(year_court_estab) & year_court_estab != 0


**Amount of crimes erased from implementation of MHCs
gen total_murder_erased = (.036/10000)*pop
gen total_rape_erased = (.13/10000)*pop
gen total_robbery_erased = (1.035/10000)*pop
gen total_assault_erased = (2.13/10000)*pop
gen total_burglary_erased = (2.947/10000)*pop
gen total_larceny_erased = (1.6/10000)*pop
gen total_vehicle_erased = (2.32/10000)*pop

**Money saved through reduced crime cost
gen money_saved_murder = total_murder_erased*(7000000)*1.42
gen money_saved_rape = total_rape_erased*(142020)*1.42
gen money_saved_robbery = total_robbery_erased*12624*1.42
gen money_saved_assault = total_assault_erased*38924*1.42
gen money_saved_burglary = total_burglary_erased*2104*1.42
gen money_saved_larceny = total_larceny_erased*473*1.42
gen money_saved_vehicle = total_vehicle_erased*5786*1.42


gen money_saved_violent = money_saved_robbery+ money_saved_rape+money_saved_assault //+money_saved_murder
gen money_saved_property = money_saved_larceny+money_saved_vehicle+money_saved_burglary
gen money_saved_total = money_saved_violent+money_saved_property

mean(money_saved_total)
