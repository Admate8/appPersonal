# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
## install.packages('attachment') # if needed.
# attachment::att_amend_desc()
usethis::use_package("pdftools", min_version = TRUE)
usethis::use_package("stringr", min_version = TRUE)
usethis::use_package("here", min_version = TRUE)
usethis::use_package("lubridate", min_version = TRUE)
usethis::use_package("dplyr", min_version = TRUE)
usethis::use_package("tidyr", min_version = TRUE)
usethis::use_package("janitor", min_version = TRUE)
usethis::use_package("bslib", min_version = TRUE)
usethis::use_package("tibble", min_version = TRUE)
usethis::use_package("htmltools", min_version = TRUE)
usethis::use_package("grDevices", min_version = TRUE)
usethis::use_package("tippy", min_version = TRUE)
usethis::use_package("glue", min_version = TRUE)
usethis::use_package("echarts4r", min_version = TRUE)
usethis::use_package("shinycssloaders", min_version = TRUE)
usethis::use_package("htmlwidgets", min_version = TRUE)
usethis::use_package("reactable", min_version = TRUE)
usethis::use_package("reactablefmtr", min_version = TRUE)
usethis::use_package("scales", min_version = TRUE)
usethis::use_package("methods", min_version = TRUE)
usethis::use_package("plotly", min_version = TRUE)
usethis::use_package("shinyWidgets", min_version = TRUE)
usethis::use_package("tidyselect", min_version = TRUE)
usethis::use_package("shinyvalidate", min_version = TRUE)
usethis::use_package("rsconnect", min_version = TRUE)
usethis::use_package("purrr", min_version = TRUE)
usethis::use_dev_package("dataui", remote = "url::https://github.com/timelyportfolio/dataui@HEAD")
usethis::use_package("shinyRatings", min_version = TRUE)
usethis::use_package("forcats", min_version = TRUE)
usethis::use_package("visNetwork", min_version = TRUE)
usethis::use_package("timevis", min_version = TRUE)
usethis::use_tidy_description()


# Documentation
## Vignette ----
usethis::use_vignette("appPersonal")
devtools::build_vignettes()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")
