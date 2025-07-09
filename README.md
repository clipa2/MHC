# The Effects of Mental Health Court Diversion Programs on Crime
Data repository for paper that evaluates the effects of mental health courts (MHCs) on crime


## Order of Code

**matched_in_R.R**: creates dataset for analysis based on propensity score matching

**crime_analysis.R**: runs regressions for total, violent, and property crime per 10,000 and specific types of crime; outputs event study figures

**heterogeneity_check.R**: runs heterogeneity regressions for crime per 10,000

**robustness_check.R**: runs robustness checks for total, violent, and property crime per 10,000 

**cost_effective_analysis.do**: cost effective analysis from paper


## Data provided

**panel.dta**: dataset before data is matched by characteristics

**matched_crime.csv**:  dataset for total, violent, and property crime matched by county characteristics for control and treatment groups used in main analysis


## References/Original data sources

Bureau of Labor Statistics. “Local Area Unemployment Statistics.” Accessed December 
6, 2023. [dataset], https://www.bls.gov/lau/tables.htm#cntyaa.

Chalfin, Aaron, and Justin McCrary. 2018. “Are U.S. Cities Underpoliced? Theory and 
Evidence.” The Review of Economics and Statistics 100 (1): 167–86. https://doi.org/10.1162/REST_a_00694.

Manson, Steven, Jonathan Schroeder, David Van Riper, Tracy Kugler, and Steven Ruggles. 
2022. “National Historical Geographic Information System: Version 17.0.” [dataset], Minneapolis, MN: IPUMS. https://doi.org/10.18128/D050.V17.0.

Substance Abuse and Mental Health Services Administration. n.d. “Adult Mental Health 
Treatment Court Locator.” https://www.samhsa.gov/gains-center/mental-health-treatment-court-locator/adults. (accessed December 2, 2023). https://github.com/user-attachments/assets/06a62331-200b-4206-b0b2-ad75e1695ae7

United States Census Bureau. “Annual Survey of State and Local Government Finances.” 
[dataset], https://www.census.gov/programs-surveys/gov-finances.html. 
https://github.com/user-attachments/assets/f277d00d-0219-44d4-825b-64ce8b296c04

United States Census Bureau. “County Business Patterns.” [dataset], 
https://www.census.gov/programs-surveys/cbp/data/datasets.html. 

United States Census Bureau. Intercensal Estimates, “County Intercensal Population Totals.” 
[dataset],
https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2010-   2020-counties.html; https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2000-2010-counties.html ; https://www.census.gov/data/tables/time-series/demo/popest/intercensal-1990-2000-state-and-county-totals.html.

United States Census Bureau. “Small Area Health Insurance Estimates.” [dataset], 
https://www.census.gov/programs-surveys/sahie.html. 

United States Department of Agriculture. Economic Research Service, County-level Data 
Sets. “Educational attainment for adults age 25 and older for the United States, States, 
and counties, 1970–2023.” [dataset], 
https://www.ers.usda.gov/data-products/county-level-data-sets/county-level-data-sets-download-data. 

United States Department of Justice. Federal Bureau of Investigation. 2018. “Uniform 
Crime Reporting Program Data: County-Level Detailed Arrest and Offense Data, United 
States, 2016: Version 3.” [dataset], ICPSR - Interuniversity Consortium for Political and Social Research. https://doi.org/10.3886/ICPSR37059.V3.
