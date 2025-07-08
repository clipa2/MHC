#------------------------------------------------------# 
# Title: Heterogeneity
# Author: Colleen Lipa
#------------------------------------------------------# 
#Set ups
rm(list = ls())
library(readr)
library(dplyr)
library(stringr)
library(rstudioapi)
library(grid)
library(haven)
library(fixest)
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
library(did)

# Data --------------------------------------------------------------------
df_annual_crime <- read.csv("matched_crime.csv") |>
  mutate(year_court_estab = ifelse(year_court_estab > 0, year_court_estab + 1,year_court_estab)) |>
  mutate(mhsa_fac = (mhsa_fac/pop)*(10000)) |>
  mutate(temp_murder = ifelse(year_court_estab > 0 & court == 0, murder_rate, NA),
         temp_rape = ifelse(year_court_estab > 0 & court == 0, rape_rate, NA),
         temp_agga = ifelse(year_court_estab > 0 & court == 0, aggravated_assault_rate, NA),
         temp_larc = ifelse(year_court_estab > 0 & court == 0, larceny_rate, NA),
         temp_burg = ifelse(year_court_estab > 0 & court == 0, burglary_rate, NA),
         temp_robb = ifelse(year_court_estab > 0 & court == 0, robbery_rate, NA),
         temp_mvt = ifelse(year_court_estab > 0 & court == 0, motor_vehicle_theft_rate, NA)) |>
  mutate(mean_murder = mean(temp_murder, na.rm = TRUE) ,
         mean_rape = mean(temp_rape, na.rm = TRUE),
         mean_aggravated_assault = mean(temp_agga, na.rm = TRUE),
         mean_larceny = mean(temp_larc, na.rm = TRUE),
         mean_burglary = mean(temp_burg, na.rm = TRUE),
         mean_robbery = mean(temp_robb, na.rm = TRUE),
         mean_motor_vehicle_theft = mean(temp_mvt, na.rm = TRUE)) |>
  mutate(murder_rate = murder_rate/mean_murder,
         rape_rate = rape_rate/mean_rape,
         aggravated_assault_rate = aggravated_assault_rate/mean_aggravated_assault,
         larceny_rate = larceny_rate/mean_larceny,
         burglary_rate = burglary_rate/mean_burglary,
         robbery_rate = robbery_rate/mean_robbery,
         motor_vehicle_theft_rate = motor_vehicle_theft_rate/mean_motor_vehicle_theft)

# Regressions -------------------------------------------------------------
model1 <- att_gt(yname = "murder_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model1 <- aggte(model1, type = "group", na.rm=TRUE)
model1 <- broom::tidy(model1) |>
  filter(group == "Average") |>
  mutate(model = "Murder") |>
  mutate(term = ifelse(term == "ATT(Average)","Murder",term)) |>
  select(term, estimate, std.error, model)


model2 <- att_gt(yname = "rape_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model2 <- aggte(model2, type = "group", na.rm=TRUE)
model2 <- broom::tidy(model2) |>
  filter(group == "Average") |>
  mutate(model = "Rape") |>
  mutate(term = ifelse(term == "ATT(Average)","Rape",term)) |>
  select(term, estimate, std.error, model)

model3 <- att_gt(yname = "robbery_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model3 <- aggte(model3, type = "group", na.rm=TRUE)
model3 <- broom::tidy(model3) |>
  filter(group == "Average") |>
  mutate(model = "Robbery") |>
  mutate(term = ifelse(term == "ATT(Average)","Robbery",term)) |>
  select(term, estimate, std.error, model)

model4 <- att_gt(yname = "burglary_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model4 <- aggte(model4, type = "group", na.rm=TRUE)
model4 <- broom::tidy(model4) |>
  filter(group == "Average") |>
  mutate(model = "Burglary") |>
  mutate(term = ifelse(term == "ATT(Average)","Burglary",term)) |>
  select(term, estimate, std.error, model)


model5 <- att_gt(yname = "larceny_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model5 <- aggte(model5, type = "group", na.rm=TRUE)
model5 <- broom::tidy(model5) |>
  filter(group == "Average") |>
  mutate(model = "Larceny") |>
  mutate(term = ifelse(term == "ATT(Average)","Larceny",term)) |>
  select(term, estimate, std.error, model)

model6 <- att_gt(yname = "aggravated_assault_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model6 <- aggte(model6, type = "group", na.rm=TRUE)
model6 <- broom::tidy(model6) |>
  filter(group == "Average") |>
  mutate(model = "Aggravated Assault") |>
  mutate(term = ifelse(term == "ATT(Average)","Aggravated Assault",term)) |>
  select(term, estimate, std.error, model)

model7 <- att_gt(yname = "motor_vehicle_theft_rate",
                 tname = "year",
                 idname = "county_state_code",
                 gname ="year_court_estab",
                 data = df_annual_crime)
model7 <- aggte(model7, type = "group", na.rm=TRUE)
model7 <- broom::tidy(model7) |>
  filter(group == "Average") |>
  mutate(model = "Motor Vehicle Theft") |>
  mutate(term = ifelse(term == "ATT(Average)","Motor Vehicle Theft",term)) |>
  select(term, estimate, std.error, model)

robstness_models <- rbind(model1, model2)
robstness_models <- rbind(robstness_models, model3)
robstness_models <- rbind(robstness_models, model4)
robstness_models <- rbind(robstness_models, model5)
robstness_models <- rbind(robstness_models, model6)
robstness_models <- rbind(robstness_models, model7)

# Graphing ----------------------------------------------------------------
robustness_check <- dwplot(robstness_models,
                           vline = geom_vline(
                             xintercept = 0,
                             colour = "black",
                             linetype = 2
                           )) + # plot line at zero _behind_ coefs
  labs(title = "Percent Change: Heterogeneity by Crime Type",
       subtitle = "",
       x = "Coefficient Estimate", 
       y = " ") +
  scale_colour_grey(
    start = .3,
    end = .3,
    name = " ",
    breaks = c(0, 1),
    labels = c(" ", " ")
   ) +
  theme(legend.position = "none")

chart_box_display(robustness_check, 4, 7)


# Save --------------------------------------------------------------------
units <- "in"
dpi <- 800
ggsave(
  file.path("heterogeneity.png"),
  robustness_check,
  width = 7,
  height = 4,
  units = units,
  bg = "white"
)
