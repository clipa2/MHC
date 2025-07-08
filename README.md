# The Effects of Mental Health Court Diversion Programs on Crime
Data repository for paper that evaluates the effects of mental health courts (MHCs) on crime


## Order of Code

**crime_analysis.do**: runs regressions for total, violent, and property crime per 10,000 and specific types of crime; outputs event study figures

**heterogeneity_check.do**: runs heterogeneity regressions for crime per 10,000

**robustness_check.do**: runs robustness checks for total, violent, and property crime per 10,000 

**cost_effective_analysis.do**: cost effective analysis from paper


## Data provided

**panel.dta**: dataset before data is matched by characteristics

**matched_crime_rates.csv**:  dataset for total, violent, and property crime matched by county characteristics for control and treatment groups


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
