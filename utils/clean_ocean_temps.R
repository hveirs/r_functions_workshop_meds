clean_ocean_temps <- function(raw_df, site_name, include_temps = c("Temp_top", "Temp_mid", "Temp_bot")) {
  
  # If the data contains these cols, clean the file
  if(all(c("year", "month", "day", "decimal_time", "Temp_bot", "Temp_mid", "Temp_top") 
         %in% colnames(raw_df))){ 
    
    message("Cleaning data...")
    site_name_formatted <- paste0(str_to_title(site_name), " Reef")
    
    #cols_to_select
    always_selected_cols <- c("year", "month", "day", "decimal_time")
    all_cols <- append(always_selected_cols, include_temps)
    
    temps_clean <- raw_df %>% 
      # select the relevant columns
      select(all_of(all_cols)) %>%
      filter(year %in% c(2005:2020)) %>% 
      # add site column
      mutate(site = rep(site_name_formatted)) %>% # rep() means to repeat something for all the rows
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
      select(any_of(c("site", "date_time", "year", "month", "day", "month_name", 
                      "Temp_bot", "Temp_mid", "Temp_top")))
    
    return(temps_clean)
    
  } else { 
    
      stop("The dataframe provided does not include the necessary columns. Please check the data.")
    
    }
  
}