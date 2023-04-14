library(tidyverse) 
library(chron)
library(naniar) 
library(ggridges)

# source for function --------
source("utils/clean_ocean_temps.R")

# Import data
alegria <- read_csv(here::here("data", "alegria_mooring_ale_20210617.csv"))

carpinteria <- read_csv(here::here("data", "carpinteria_mooring_car_20220330.csv"))

mohawk <- read_csv(here::here("data", "mohawk_mooring_mko_20220330.csv"))

# Use function!
alegria_clean <- clean_ocean_temps(raw_df = alegria, site_name = "alegria")

mohawk_clean <- clean_ocean_temps(mohawk, site_name = "mohawk")

carpinteria_clean <- clean_ocean_temps(carpinteria, site_name = "CARPINTERIA", 
                                       include_temps = c("Temp_bot", "Temp_top"))
