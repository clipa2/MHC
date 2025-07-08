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
library(did)

# Data --------------------------------------------------------------------
df_annual_crime <- read.csv("matched_crime.csv") |>
  mutate(year_court_estab = ifelse(year_court_estab > 0, year_court_estab + 1,year_court_estab))|>
  mutate(mhsa_fac = (mhsa_fac/pop)*(10000))


# Regressions -------------------------------------------------------------
total_crime.lm <- att_gt(yname = "total_crime_rate",
                         tname = "year",
                         idname = "county_state_code",
                         gname ="year_court_estab",
                         data = df_annual_crime)
total_crime.gs <- aggte(total_crime.lm, type = "dynamic", na.rm=TRUE)
overall_tot <-  aggte(total_crime.lm,type="group",na.rm=TRUE)
summary(overall_tot)

violent_crime.lm <- att_gt(yname = "violent_crime_rate",
                           tname = "year",
                           idname = "county_state_code",
                           gname ="year_court_estab",
                           data = df_annual_crime)
violent_crime.gs <- aggte(violent_crime.lm, type = "dynamic", na.rm=TRUE)
overall_vio <-  aggte(violent_crime.lm,type="group",na.rm=TRUE)
summary(overall_vio)

property_crime.lm <- att_gt(yname = "property_crime_rate",
                            tname = "year",
                            idname = "county_state_code",
                            gname ="year_court_estab",
                            data = df_annual_crime)
property_crime.gs <- aggte(property_crime.lm, type = "dynamic", na.rm=TRUE)
overall_prop <-  aggte(property_crime.lm,type="group",na.rm=TRUE)
summary(overall_prop)

murder.lm <- att_gt(yname = "murder_rate",
                    tname = "year",
                    idname = "county_state_code",
                    gname ="year_court_estab",
                    data = df_annual_crime)
murder.gs <- aggte(murder.lm, type = "dynamic", na.rm=TRUE)
overall_murder <-  aggte(murder.lm,type="group",na.rm=TRUE)
summary(overall_murder)

rape.lm <- att_gt(yname = "rape_rate",
                  tname = "year",
                  idname = "county_state_code",
                  gname ="year_court_estab",
                  data = df_annual_crime)
rape.gs <- aggte(rape.lm, type = "dynamic", na.rm=TRUE)
overall_rape <-  aggte(rape.lm,type="group",na.rm=TRUE)
summary(overall_rape)

robbery.lm <- att_gt(yname = "robbery_rate",
                     tname = "year",
                     idname = "county_state_code",
                     gname ="year_court_estab",
                     data = df_annual_crime)
robbery.gs <- aggte(robbery.lm, type = "dynamic", na.rm=TRUE)
overall_robb <-  aggte(robbery.lm,type="group",na.rm=TRUE)
summary(overall_robb)

burglary.lm <- att_gt(yname = "burglary_rate",
                      tname = "year",
                      idname = "county_state_code",
                      gname ="year_court_estab",
                      data = df_annual_crime)
burglary.gs <- aggte(burglary.lm, type = "dynamic", na.rm=TRUE)
overall_burg <-  aggte(burglary.lm,type="group",na.rm=TRUE)
summary(overall_burg)

larceny.lm <- att_gt(yname = "larceny_rate",
                     tname = "year",
                     idname = "county_state_code",
                     gname ="year_court_estab",
                     data = df_annual_crime)
larceny.gs <- aggte(larceny.lm, type = "dynamic", na.rm=TRUE)
overall_lar <-  aggte(larceny.lm,type="group",na.rm=TRUE)
summary(overall_lar)

aggravated_assault.lm <- att_gt(yname = "aggravated_assault_rate",
                                tname = "year",
                                idname = "county_state_code",
                                gname ="year_court_estab",
                                data = df_annual_crime)
aggravated_assault.gs <- aggte(aggravated_assault.lm, type = "dynamic", na.rm=TRUE)
overall_aa <-  aggte(aggravated_assault.lm,type="group",na.rm=TRUE)
summary(overall_aa)

motor_vehicle_theft.lm <- att_gt(yname = "motor_vehicle_theft_rate",
                                 tname = "year",
                                 idname = "county_state_code",
                                 gname ="year_court_estab",
                                 data = df_annual_crime)
motor_vehicle_theft.gs <- aggte(motor_vehicle_theft.lm, type = "dynamic", na.rm=TRUE)
overall_mvt <-  aggte(motor_vehicle_theft.lm,type="group",na.rm=TRUE)
summary(overall_mvt)

# Graphing ----------------------------------------------------------------

chart_list <- list(
  list(var = "total_crime", titleA = "Callaway and Sant'Anna", title = "Total Crime per 10,000", baseterms = total_crime.gs),
  list(var = "violent_crime", titleA = "", title = "Violent Crime per 10,000", baseterms = violent_crime.gs),
  list(var = "property_crime", titleA = "", title = "Property Crime per 10,000", baseterms = property_crime.gs),
  list(var = "murder", titleA = "Callaway and Sant'Anna", title = "Murders per 10,000", baseterms = murder.gs),
  list(var = "rape", titleA = "", title = "Rapes per 10,000", baseterms = rape.gs),
  list(var = "robbery", titleA = "", title = "Robberies per 10,000", baseterms = robbery.gs),
  list(var = "burglary", titleA = "", title = "Burglaries per 10,000", baseterms = burglary.gs),
  list(var = "larceny", titleA = "", title = "Larcenies per 10,000", baseterms = larceny.gs),
  list(var = "aggravated_assault", titleA = "", title = "Aggravated Assaults per 10,000", baseterms = aggravated_assault.gs),
  list(var = "motor_vehicle_theft", titleA = "", title = "Motor Vehicle Thefts per 10,000", baseterms = motor_vehicle_theft.gs)
  )


for (i in seq_along(chart_list)){ 
  macros <- chart_list[[i]]
  plot_name <- paste(macros$var, "fig", sep = "_")

  plot <- ggdid(macros$baseterms) +
    scale_x_continuous(
      limits = c(-25,25),
      breaks = seq(-25,25,5)
    ) + 
    labs(title = macros$titleA,
         subtitle = macros$title,
         x = "Years a MHC has been in a county", 
         y = "Coefficient Estimate") +
    ylab(NULL) +
    geom_vline(xintercept = 0, linetype = "dashed", size = 0.5, color = "gray30") + 
    theme(legend.position = "none") 
  
  
  assign(plot_name, plot, envir = .GlobalEnv) 
  
}


row <- plot_grid(total_crime_fig, violent_crime_fig, property_crime_fig, align = 'h', rel_widths = c(1, 1), nrow = 1)
row2 <- plot_grid(murder_fig, rape_fig, robbery_fig, burglary_fig, larceny_fig, aggravated_assault_fig, motor_vehicle_theft_fig, align = 'h', rel_widths = c(1, 1), nrow = 3)

chart_box_display(row, 3.9, 3.2*3.1)
chart_box_display(row2, 3.9*3, 3.2*3)

units <- "in"
dpi <- 800
# Save --------------------------------------------------------------------
ggsave(
  file.path("callaway.png"),
  row,
  width = 3.9*3.1,
  height = 3.2,
  units = units,
  bg = "white"
)

ggsave(
  file.path("callaway_heterogeneity.png"),
  row2,
  width = 3.9*3,
  height = 3.2*3,
  units = units,
  bg = "white"
)


temp <- df_annual_crime |>
  filter(year_court_estab > 0) |>
  filter(court == 0)
mean(temp$total_crime_rate)
mean(temp$violent_crime_rate)
mean(temp$property_crime_rate)
mean(temp$murder_rate)
mean(temp$aggravated_assault_rate)
mean(temp$robbery_rate)
mean(temp$burglary_rate)
mean(temp$motor_vehicle_theft_rate)
