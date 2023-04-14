# Load packages -------
library(tidyverse)
library(chron)
library(naniar)
library(ggridges)

# Load in data --------
alegria <- read_csv(here::here("data", "alegria_mooring_ale_20210617.csv"))

carpinteria <- read_csv(here::here("data", "carpinteria_mooring_car_20220330.csv"))

mohawk <- read_csv(here::here("data", "mohawk_mooring_mko_20220330.csv"))


# Clean the data -------
alegria_clean <- alegria %>% 
  # select the relevant columns
  select(year, month, day, decimal_time, Temp_bot, Temp_mid, Temp_top) %>%
  filter(year %in% c(2005:2020)) %>% 
  # add site column
  mutate(site = rep("Alegria Reef")) %>% # rep() means to repeat something for all the rows
  # make a date time column 
  unite(col = date, year, month, day, sep = "-", remove = FALSE) %>% 
  mutate(time = times(decimal_time)) %>%
  unite(col = date_time, date, time, sep = " ", remove = TRUE) %>% 
  # Coerce the date_time column into a date-time object using POSIXct
  mutate(date_time = as.POSIXct(date_time, "%Y-%m-%d %H:%M:%S", tz = "GMT"),
         year = as.factor(year), 
         month = as.factor(month), 
         day = as.numeric(day)) %>% 
  # replace 9999 with NAs
  replace_with_na(replace = list(Temp_bot = 9999, Temp_mid = 9999, Temp_top = 9999)) %>% 
  # reorder columns
  mutate(month_name = as.factor(month.name[month])) %>%
  select(site, date_time, year, month, day, month_name, Temp_bot, Temp_mid, Temp_top)

# Plot the data for alegria -----------
alegria_plot <- alegria_clean %>% 
  group_by(month_name) %>% 
  ggplot(aes(x = Temp_bot, y = month_name, fill = after_stat(x))) + 
  geom_density_ridges_gradient(rel_min_height = 0.01, scale = 3) + 
  scale_x_continuous(breaks = c(9, 12, 15, 18, 21)) + 
  scale_y_discrete(limits = rev(month.name)) + 
  scale_fill_gradientn(colors = c("#2C5374","#778798", "#ADD8E6", "#EF8080", "#8B3A3A"), 
                       name = "Temp. (°C)") + 
  labs(x = "Bottom Temperature (°C)", 
       title = "Bottom Temperatures at Alegria Reef, Santa Barbara, CA", 
       subtitle = "Temperatures (°C) aggregated by month from 2005-2020") + 
  theme_ridges(font_size = 13, grid = TRUE) + 
  theme(axis.title.y = element_blank())
  
alegria_plot

# Shift + option + 8 = ° degree symbol
