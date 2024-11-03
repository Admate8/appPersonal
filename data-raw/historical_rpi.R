# Code to prepare `df_historical_rpi` dataset

# ONS API currently (as of writing this code) doesn't allow scrapping the RPI
# data, and it must first be saved locally before processing

file_path <- file.path(here::here(), "data/data-source/historical_RPI.csv")

df_historical_rpi <- utils::read.csv(file_path) |>
  # Begin from March 2018 - adjust to be March of the year you started uni
  dplyr::slice(1224:dplyr::n()) |>
  `colnames<-`(c("date", "rpi")) |>
  dplyr::mutate(
    date = lubridate::parse_date_time(paste0(date, " 01"), orders = "ymd"),
    rpi  = as.numeric(rpi)
  ) |>
  # All example data will end in 2023/24 FY
  dplyr::filter(date <= as.Date("2024-03-01"))

usethis::use_data(df_historical_rpi, overwrite = TRUE)
