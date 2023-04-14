library(tidyverse) 
library(chron)
library(naniar) 
library(ggridges)
library(stringr)

# source for function --------
source("utils/clean_ocean_temps.R")

temp_files <- list.files(path = "data", pattern = ".csv")

# For loop to read in data
for (i in 1:length(temp_files)) {
  
  # get object name from the file name
  file_name <- temp_files[i]
  message("Reading in: ", file_name)
  split_name <- stringr::str_split(file_name, "_")
  site_name <- split_name[[1]][1]
  message("Saving as: ", site_name)
  
  # Read in data
  assign(x = site_name, value = read_csv(here::here("data", file_name)))
}
