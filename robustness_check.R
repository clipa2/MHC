#------------------------------------------------------# 
# Author: Colleen Lipa
# Description: Robustness Checks

# A) Callaway & Sant'Anna
# B) Callaway & Sant'Anna, not yet treated
# C) Callaway & Sant'Anna, no lag for treatment
# D) Callaway & Sant'Anna, clustering by county-state-code
# E) Callaway & Sant'Anna, removing 2015+ yearly data 
# F) Callaway & Sant'Anna, removing 2015+ data for year_court_established
# G) Callaway & Sant'Anna, keeping data after 1997
# H) Callaway & Sant'Anna, unmatched balanced panel
# I) Callaway & Sant'Anna, population restriction of 80,000+
# J) TWFE
# K) Callaway & Sant'Anna, time invarient characteristics

#------------------------------------------------------# 
#Set ups
rm(list = ls())
library(readr)
library(dplyr)
library(stringr)
library(rstudioapi)
library(grid)
library(haven)
library(broom)
library(ggplot2)
library(cowplot)
library(gridExtra)
library(qpdf)
library(car)
library(plm)
library(AER)
library(fixest)
library(dotwhisker)

# Data --------------------------------------------------------------------
df_annual_crime <- read.csv("matched_crime.csv") |>
  mutate(year_court_estab = ifelse(year_court_estab > 0, year_court_estab + 1,year_court_estab)) |>
  mutate(mhsa_fac = (mhsa_fac/pop)*(10000))


chart_list <- list(
  list(var = "total_crime_rate", titleA = "Robustness Check", title = "Total Crime per 10,000"),
  list(var = "violent_crime_rate", titleA = "", title = "Violent Crime per 10,000"),
  list(var = "property_crime_rate", titleA = "", title = "Property Crime per 10,000"),
  list(var = "murder_rate", titleA = "Robustness Check", title = "Murders per 10,000"),
  list(var = "rape_rate", titleA = "", title = "Rapes per 10,000"),
  list(var = "robbery_rate", titleA = "", title = "Robberies per 10,000"),
  list(var = "burglary_rate", titleA = "", title = "Burglaries per 10,000"),
  list(var = "larceny_rate", titleA = "", title = "Larcenies per 10,000"),
  list(var = "aggravated_assault_rate", titleA = "", title = "Aggravated Assaults per 10,000"),
  list(var = "motor_vehicle_theft_rate", titleA = "", title = "Motor Vehicle Thefts per 10,000")
)

for (i in seq_along(chart_list)){ 
  macros <- chart_list[[i]]
  plot_name <- paste(macros$var, "fig", sep = "_")
# Regressions -------------------------------------------------------------
modelA <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
modelA <- aggte(modelA, type = "group", na.rm=TRUE)
modelA <- broom::tidy(modelA) |>
  filter(group == "Average") |>
  mutate(model = "Main Estimate") |>
  mutate(term = ifelse(term == "ATT(Average)","Main Estimate",term)) |>
  select(term, estimate, std.error, model)

modelB <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 control_group = "notyettreated",
                 data = df_annual_crime)
modelB <- aggte(modelB, type = "group", na.rm=TRUE)
modelB <- broom::tidy(modelB) |>
  filter(group == "Average") |>
  mutate(model = "Control=Not Yet Treated") |>
  mutate(term = ifelse(term == "ATT(Average)","Control=Not Yet Treated",term)) |>
  select(term, estimate, std.error, model)

df_annual_crime_C <- df_annual_crime |>
  mutate(year_court_estab = ifelse(year_court_estab > 0, year_court_estab - 1,year_court_estab))

modelC <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime_C)
modelC <- aggte(modelC, type = "group", na.rm=TRUE)
modelC <- broom::tidy(modelC) |>
  filter(group == "Average") |>
  mutate(model = "No Lag for Treatment") |>
  mutate(term = ifelse(term == "ATT(Average)","No Lag for Treatment",term)) |>
  select(term, estimate, std.error, model)

modelD <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 clustervars = "state_code",
                 data = df_annual_crime)
modelD <- aggte(modelD, type = "group", na.rm=TRUE)
modelD <- broom::tidy(modelD) |>
  filter(group == "Average") |>
  mutate(model = "Clustering by State") |>
  mutate(term = ifelse(term == "ATT(Average)","Clustering by State",term)) |>
  select(term, estimate, std.error, model)

df_annual_crime_E <- df_annual_crime |>
  filter(year < 2015)

modelE <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime_E)
modelE <- aggte(modelE, type = "group", na.rm=TRUE)
modelE <- broom::tidy(modelE) |>
  filter(group == "Average") |>
  mutate(model = "Removing Years >= 2015") |>
  mutate(term = ifelse(term == "ATT(Average)","Removing Years >= 2015",term)) |>
  select(term, estimate, std.error, model)

df_annual_crime_F <- df_annual_crime |>
  filter(year_court_estab < 2015)

modelF <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime_F)
modelF <- aggte(modelF, type = "group", na.rm=TRUE)
modelF <- broom::tidy(modelF) |>
  filter(group == "Average") |>
  mutate(model = "Removing Counties with MHCs Established After 2015") |>
  mutate(term = ifelse(term == "ATT(Average)","Removing Counties with MHCs\nEstablished After 2015",term)) |>
  select(term, estimate, std.error, model)

df_annual_crime_G <- df_annual_crime |>
  filter(year >  1997)

modelG <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime_G)
modelG <- aggte(modelG, type = "group", na.rm=TRUE)
modelG <- broom::tidy(modelG) |>
  filter(group == "Average") |>
  mutate(model = "Data after 1997") |>
  mutate(term = ifelse(term == "ATT(Average)","Data after 1997",term)) |>
  select(term, estimate, std.error, model)

crime_data <- read_dta("panel.dta") |>
  mutate(year_court_estab = ifelse(year_court_estab > 0, year_court_estab + 1,year_court_estab))
  
modelH <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = crime_data)
modelH <- aggte(modelH, type = "group", na.rm=TRUE)
modelH <- broom::tidy(modelH) |>
  filter(group == "Average") |>
  mutate(model = "Unmatched Data") |>
  mutate(term = ifelse(term == "ATT(Average)","Unmatched Data",term)) |>
  select(term, estimate, std.error, model)

crime_data_I <- crime_data |>
  filter(max_pop > 80000)

modelI <- att_gt(yname = macros$var,
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = crime_data_I)
modelI <- aggte(modelI, type = "group", na.rm=TRUE)
modelI <- broom::tidy(modelI) |>
  filter(group == "Average") |>
  mutate(model = "Counties with populations > 80,000") |>
  mutate(term = ifelse(term == "ATT(Average)","Counties with populations > 80,000",term)) |>
  select(term, estimate, std.error, model)

df_annual_crime_J <- df_annual_crime |>
  rename(crime_variable = macros$var)

modelJ <- feols(
  crime_variable ~ court + pop + mhsa_fac + unemployment_rate + 
  deaths_per_10000 + not_hsg + college + income_per_capita + per_medicaid + per_female +
  under_18 + over_65 +  per_white +  percent_pov + per_uninsured | state_code*year + county_state_code, #
  data = df_annual_crime_J)
modelJ <- broom::tidy(modelJ) |>
   filter(grepl('court', term))|>
  mutate(model = "TWFE")|>
  mutate(term = ifelse(term == "court","TWFE",term)) |>
  select(term, estimate, std.error, model)

modelK <- att_gt(yname = macros$var,
                     tname = "year",
                     idname = "county_state_code",
                     gname ="year_court_estab",
                     xformla = ~per_white + per_female + under_18 + not_hsg + income_per_capita + percent_pov,
                     data = df_annual_crime)
modelK <- aggte(modelK, type = "group", na.rm=TRUE)

modelK <- broom::tidy(modelK) |>
  filter(group == "Average") |>
  mutate(model = "Characteristics Controls") |>
  mutate(term = ifelse(term == "ATT(Average)","Characteristics Controls",term)) |>
  select(term, estimate, std.error, model)


robstness_models <- rbind(modelA, modelB)
robstness_models <- rbind(robstness_models, modelC)
robstness_models <- rbind(robstness_models, modelD)
robstness_models <- rbind(robstness_models, modelE)
robstness_models <- rbind(robstness_models, modelF)
robstness_models <- rbind(robstness_models, modelG)
robstness_models <- rbind(robstness_models, modelH)
robstness_models <- rbind(robstness_models, modelI)
robstness_models <- rbind(robstness_models, modelJ)
robstness_models <- rbind(robstness_models, modelK)

# Graphing ----------------------------------------------------------------
robustness_check <- dwplot(robstness_models,
       vline = geom_vline(
         xintercept = 0,
         colour = "black",
         linetype = 2
       )) + # plot line at zero _behind_ coefs
  labs(title = macros$titleA,
       subtitle = macros$title,
       x = "Coefficient Estimate", 
       y = " ") +
  scale_colour_grey(
    start = .3,
    end = .3,
    name = "Transmission",
    breaks = c(0, 1),
    labels = c("Automatic", "Manual")
  ) +
  theme(legend.position = "none")

chart_box_display(robustness_check, 5, 8)

assign(plot_name, robustness_check, envir = .GlobalEnv) 

}
chart_box_display(total_crime_rate_fig, 3.2, 3.9*2)


row <- plot_grid(total_crime_rate_fig, violent_crime_rate_fig, property_crime_rate_fig, align = 'h', rel_widths = c(1, 1), nrow = 1)
row2 <- plot_grid(murder_rate_fig, rape_rate_fig, robbery_rate_fig, burglary_rate_fig, larceny_rate_fig, aggravated_assault_rate_fig, motor_vehicle_theft_rate_fig, align = 'h', rel_widths = c(1, 1), nrow = 3)

chart_box_display(row, 3.2*1.2, 3.9*5)
chart_box_display(row2, 10, 16)

# Save --------------------------------------------------------------------
units <- "in"
dpi <- 800
ggsave(
  file.path("robustness.png"),
  row,
  width = 3.9*5,
  height = 3.2*1.2,
  units = units,
  bg = "white"
)

ggsave(
  file.path("robustness_heterogeneity.png"),
  row2,
  width = 16,
  height = 10,
  units = units,
  bg = "white"
)
