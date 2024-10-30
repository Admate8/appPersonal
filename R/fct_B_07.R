
# Data & Code for the Transactions Table ----------------------------------


#' Prepare Data for the Most Often / Biggest Transactions
#'
#' @param selected_month Date of the form "YYYY-MM-DD", e.g. "2023-01-01".
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#'
#' @return Data ready to be fed into two tables - most often and biggest transactions.
#' @noRd
get_df_transactions_tables <- function(selected_month, df_transactions) {

  # Check if the data contains specified date
  if (selected_month %notin% lubridate::floor_date(df_transactions$date, unit = "month")) {
    base::stop(base::paste("Select date must be between", base::format(base::min(df_transactions$date), "%Y-%m"), "and", base::format(base::max(df_transactions$date), "%Y-%m")))
  }
  df_transactions |>
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>

    # This piece of code might be useful when dealing with actual bank statements
    # dplyr::mutate(
    #   name = base::sapply(base::strsplit(description, ","), function(x) x[2]),
    #   name = base::ifelse(is.na(name), description, name),
    #   name = base::trimws(name),
    #   name = base::gsub("\\d", "", name)
    # ) |>
    dplyr::filter(date_month == selected_month) |>
    dplyr::mutate(date = base::format(date, "%d/%m/%y")) |>
    dplyr::select(date, description, spend = value, category) |>
    dplyr::arrange(dplyr::desc(spend)) |>
    dplyr::left_join(col_palette_categories, by = dplyr::join_by(category))
}


#' Table: the Biggest Spend
#'
#' @inheritParams appPersonal::get_df_transactions_tables
#'
#' @return reactable table
#' @noRd
table_spend_biggest_spend <- function(selected_month, df_transactions) {

  df_transformations_biggest_spend <- get_df_transactions_tables(selected_month, df_transactions)
  df_transformations_biggest_spend |>
    reactable::reactable(
      compact         = TRUE,
      highlight       = TRUE,
      defaultPageSize = 5,
      wrap            = FALSE,
      paginationType  = "simple",
      columns         = list(
        date     = reactable::colDef(width = 80, name = "Date"),
        spend    = reactable::colDef(width = 75, name = "Spend", format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE)),
        category = reactable::colDef(width = 120, name = "Category", cell = reactablefmtr::pill_buttons(data = df_transformations_biggest_spend, color_ref = "color")),
        color    = reactable::colDef(show = FALSE)
      )
    )
}

#' Table: the Most Frequent Transactions
#'
#' @inheritParams appPersonal::get_df_transactions_tables
#'
#' @return reactable table
#' @noRd
table_spend_most_often <- function(selected_month, df_transactions) {

  df_transformations_most_often <- get_df_transactions_tables(selected_month, df_transactions) |>
    dplyr::count(description, category, color, name = "count", sort = TRUE) |>
    dplyr::select(description, count, category, color)

  df_transformations_most_often |>
    reactable::reactable(
      compact         = TRUE,
      highlight       = TRUE,
      defaultPageSize = 5,
      wrap            = FALSE,
      paginationType  = "simple",
      columns         = list(
        count    = reactable::colDef(width = 55, name = "Count"),
        category = reactable::colDef(width = 120, name = "Category", cell = reactablefmtr::pill_buttons(data = df_transformations_most_often, color_ref = "color")),
        color    = reactable::colDef(show = FALSE)
      )
    )
}


