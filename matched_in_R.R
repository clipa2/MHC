rm(list =ls())
library(MatchIt)
library(cobalt)

# Read in Data ------------------------------------------------------------
crime_data <- read_dta("panel.dta") |>
  filter(year == 1994) |>
  mutate(court = ifelse(year_court_estab > 0, 1, 0))|>
  mutate(mhsa_fac = (mhsa_fac/pop)*(10000))
crime_data[is.na(crime_data)] <- 0


# Match data (by characteristics) -----------------------------------------
matched_crime <- matchit(court ~ pop + unemployment_rate + not_hsg + college + income_per_capita + per_female + under_18 + over_65 + per_white
                                 +  percent_pov + per_uninsured, data = crime_data)

# Plot data ---------------------------------------------------------------
love.plot(matched_crime)

# Grab data ---------------------------------------------------------------
matched_crime_data <- match.data(matched_crime)|>
  select(fips) |>
  mutate(matched = 1)

# Merge onto data (keeping only matched data) -----------------------------
crime_data <- read_dta("panel.dta")
crime_data <- left_join(crime_data, matched_crime_data, by = "fips") |>
  filter(matched == 1)

# save data ---------------------------------------------------------------
write.csv(crime_data, "matched_crime.csv", row.names = FALSE, na = "")
