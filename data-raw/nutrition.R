# Code to scrape FatSecret CSV data and prepare `df_nutrition` dataset

#' Clean Raw FatSecret CSV Data
#'
#' @param link Link from the app containing detailed weekly report in CSV.
#' @param date_start Beginning of the week date (Monday).
#'
#' @return Preprocessed data in rectangular shape.
#' @noRd
tidy_table_meals <- function(link, date_start) {
  stopifnot("'date_start' must be a date" = lubridate::is.Date(date_start))

  # This will throw a warning - ignore it as we will adress the problem later
  all_pages <- readr::read_csv(link) |> dplyr::slice(-c(1:14))
  names(all_pages) <- "All"

  all_pages <- all_pages |>
    dplyr::filter(grepl("Fat|Total|Breakfast|Dinner|Snack|Lunch", All)) |>
    tidyr::separate(col = All, into = c("MealType", "Value1", "Value2", "Value3", "Value4", "Value5", "Value6", "Value7", "Value8", "Value9", "Value10"), sep = ",") |>
    dplyr::filter(MealType %in% c("Date", "Breakfast", "Lunch", "Dinner", "Snacks/Other"))

  names(all_pages) <- c("Type", sub(" .*|\\(.*", "", all_pages[1, ][2:11]))
  all_pages |>
    dplyr::slice(-1) |>
    dplyr::mutate(Date = rep(seq.Date(date_start, date_start + 6, by = "days"), each = 4)) |>
    dplyr::mutate_at(dplyr::vars(2:11), as.numeric) |>
    janitor::clean_names()
}

# Make sure this looks okay
# tidy_table_meals(link_from_fatsecret, date_start) |> View()

# Now you can add the data at the bottom of existing data

# current_table <- utils::read.csv("...")
#
# rbind(
#   current_table,
#   tidy_table_meals(link_from_fatsecret, date_start)
# ) |>
#   utils::write.csv("...")

