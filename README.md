# The Effects of Mental Health Court Diversion Programs on Crime and Homelessness
Data repository for paper that evaluates the effects of mental health courts (MHCs) on crime and homelessness


## Order of Code

**crime_analysis.do**: runs regressions for total, violent, and property crime per 10,000

**homelessness_analysis.do**: runs regressions for homelessness per 10,000

**event_study.do**: runs event study (code modified from https://stats.github.io/Model_Estimation/Research_Design/event_study.html)

**heterogeneity_check.do**: runs heterogeneity regressions for crime per 10,000

**robustness_check.do**: runs robustness checks for total, violent, and property crime per 10,000 and homelessness

**cost_benefit_analysis.do**: cost benefit analysis from paper


## Data provided

**crime_data.dta**: main dataset for total, violent, and property crime analysis

**homelessness_data.dta**: main dataset for homelessness analysis

**crime_all_data.dta**: complete dataset for total, violent, and property crime regressions without population restriction

**homeless_all_data.dta**: complete dataset for homelessness regressions without population restriction

**matched_crime_rates.csv**:  dataset for total, violent, and property crime matched by county characteristics for control and treatment groups

**matched_homelessness.dta**: dataset for homelessness matched by county characteristics for control and treatment groups


## References/Original data sources

Chalfin, Aaron, and Justin McCrary. 2018. “Are U.S. Cities Underpoliced? Theory and 
Evidence.” The Review of Economics and Statistics 100 (1): 167–86. https://doi.org/10.1162/REST_a_00694.

“Local Area Unemployment Statistics.” n.d. Accessed December 6, 2023. 
https://www.bls.gov/lau/tables.htm#cntyaa.

Manson, Steven, Jonathan Schroeder, David Van Riper, Tracy Kugler, and Steven Ruggles. 
2022. “National Historical Geographic Information System: Version 17.0.” Minneapolis, MN: IPUMS. https://doi.org/10.18128/D050.V17.0.

“PIT and HIC Data Since 2007.” n.d. HUD Exchange. Accessed April 6, 2024. 
https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007.

Substance Abuse and Mental Health Services Administration. n.d. “Adult Mental Health 
Treatment Court Locator.” Accessed December 2, 2023. https://www.samhsa.gov/gains-center/mental-health-treatment-court-locator/adults.

United States Department of Justice. Federal Bureau of Investigation. 2018. “Uniform Crime 
Reporting Program Data: County-Level Detailed Arrest and Offense Data, United States, 2016: Version 3.” ICPSR - Interuniversity Consortium for Political and Social Research. https://doi.org/10.3886/ICPSR37059.V3.

US Census. n.d. “Substantial Changes to Counties and County Equivalent Entities: 1970-
Present.” Census.Gov. Accessed February 14, 2024. https://www.census.gov/programs -surveys/geography/technical-documentation/county-changes.html.

“US Intercensal Population by County and State 1970-on | NBER.” n.d. Accessed January 3, 
2024. https://www.nber.org/research/data/us-intercensal-population-county-and-state-1970.
