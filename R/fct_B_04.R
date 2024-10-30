
# Data & Code for the Spend Comparison Table ------------------------------


#' Add Remainder to the Monthly Transactions Data
#'
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#' @param df_earnings Data with monthly earnings. See \code{appPersonal::df_earnings} as an example.
#' @noRd
calc_remainder_month <- function(df_transactions, df_earnings) {

  # Compute the spend per month
  df_spend_per_month <- df_transactions |>
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date_month, category) |>
    dplyr::summarise(spend = base::sum(value), .groups = "drop")

  # Compute how much was left after each month
  df_left_per_month <- df_transactions |>
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date_month) |>
    dplyr::summarise(spend = base::sum(value), .groups = "drop") |>
    dplyr::left_join(
      df_earnings |> dplyr::select(date, monthly_net),
      by = dplyr::join_by(date_month == date)
    ) |>
    dplyr::mutate(category = "Remainder", spend = monthly_net - spend, .keep = "unused")

  # Combine them into one data frame
  df_spend_comparison <- base::rbind(
    df_spend_per_month,
    df_left_per_month
  )

  return(df_spend_comparison)
}


#' Prepare Data for the Spend Comparison Tables
#'
#' @param date The latest available date in the earnings data. This
#' argument will be inherited from \code{golem::get_golem_options("operating_month")}
#' to allow dynamic change.
#' @inheritParams appPersonal::calc_remainder_month
#' @noRd
get_df_spend_comparison <- function(date, df_transactions, df_earnings) {

  df_spend_comparison <- calc_remainder_month(df_transactions, df_earnings)

  ## Prepare the data for the spend comparison table by calculating:
  # Spend from the operating month
  df_spend_comparison_0mo <- df_spend_comparison |>
    dplyr::filter(date_month == date) |>
    dplyr::select(-date_month) |>
    dplyr::mutate(period = "month_current")

  # Spend from the month preceding the operating month
  df_spend_comparison_1mo <- df_spend_comparison |>
    dplyr::filter(date_month == date - base::months(1)) |>
    dplyr::select(-date_month) |>
    dplyr::mutate(period = "month_previous")

  # Average three months spend
  df_spend_comparison_3mo_avg <- df_spend_comparison |>
    dplyr::filter(dplyr::between(
      date_month,
      date - base::months(4),
      date - base::months(1)
    )) |>
    dplyr::group_by(category) |>
    dplyr::summarise(spend = base::mean(spend), .groups = "drop") |>
    dplyr::mutate(period = "three_months_average")

  # Average six months spend
  df_spend_comparison_6mo_avg <- df_spend_comparison |>
    dplyr::filter(dplyr::between(
      date_month,
      date - base::months(7),
      date - base::months(1)
    )) |>
    dplyr::group_by(category) |>
    dplyr::summarise(spend = base::mean(spend), .groups = "drop") |>
    dplyr::mutate(period = "six_months_average")

  # Combine them into the final data and reshape
  df_spend_comparison_ready <- base::rbind(
    df_spend_comparison_0mo,
    df_spend_comparison_1mo,
    df_spend_comparison_3mo_avg,
    df_spend_comparison_6mo_avg
  ) |>
    tidyr::pivot_wider(
      names_from  = period,
      values_from = spend,
      values_fill = 0L
    ) |>
    dplyr::mutate(
      # Calculate percentage change with respect to the current month
      change_prev_month = dplyr::case_when(
        month_previous <= 0 ~ 1,
        month_current <= 0 ~ -1,
        TRUE ~ month_current / month_previous - 1
      ),
      change_three_months_avg = dplyr::case_when(
        three_months_average == 0 ~ 1,
        month_current <= 0 ~ -1,
        TRUE ~ month_current / three_months_average - 1
      ),
      change_six_months_avg = dplyr::case_when(
        six_months_average == 0 ~ 1,
        month_current <= 0 ~ -1,
        TRUE ~ month_current / six_months_average - 1
      ),

      # Add tex colours for convenience to ease later render in the table
      month_previous_col = dplyr::case_when(
        category %in% c("Savings", "Investments", "Remainder") ~ base::ifelse(month_current < month_previous, "red", "green"),
        TRUE ~ base::ifelse(month_current >= month_previous, "red", "green")
      ),
      three_months_previous_col = dplyr::case_when(
        category %in% c("Savings", "Investments", "Remainder") ~ base::ifelse(month_current < three_months_average, "red", "green"),
        TRUE ~ base::ifelse(month_current >= three_months_average, "red", "green")
      ),
      six_months_previous_col = dplyr::case_when(
        category %in% c("Savings", "Investments", "Remainder") ~ base::ifelse(month_current < six_months_average, "red", "green"),
        TRUE ~ base::ifelse(month_current >= six_months_average, "red", "green")
      )
    ) |>
    # Join colours to make pills in the table
    dplyr::left_join(col_palette_categories, by = dplyr::join_by(category))

  # Reorder the first column to match the order from the plots
  df_spend_comparison_ready[base::order(base::match(df_spend_comparison_ready$category, col_palette_categories$category)),]
}


#' Custom Styling for the Percentage Spend Comparison Table
#'
#' @param value Value from the table
#' @param index Row index of the table
#'
#' @return A list containing style options for the table column
#' @noRd
style_spend_comparison_values_perc <- function(value, index) {
  base::stopifnot(is.numeric(value), is.integer(index), index > 0)

  if (value > 0 & index %notin% c(2, 3, 11)) color <- "#e00000"
  else if (value >= 0 & index %in% c(2, 3, 11)) color <- "#008000"
  else if (value <= 0 & index %notin% c(2, 3, 11)) color <- "#008000"
  else if (value < 0 & index %in% c(2, 3, 11)) color <- "#e00000"
  else color <- "#777"
  list(color = color, borderRight = "1px solid rgba(0, 0, 0, 0.1)")
}


#' Plot the Spend Comparison Table
#'
#' @inheritParams appPersonal::get_df_spend_comparison
#' @noRd
table_spend_comparison <- function(date, df_transactions, df_earnings) {

  df <- get_df_spend_comparison(date, df_transactions, df_earnings)

  df |>
    dplyr::select(category, month_current, month_previous, three_months_average, six_months_average, contains("col"), color) |>
    reactable::reactable(
      defaultPageSize = 11,
      compact         = TRUE,
      highlight       = TRUE,

      columns = list(
        category = reactable::colDef(
          name   = "Category",
          cell   = reactablefmtr::pill_buttons(data = df, color_ref = "color"),
          width  = 130,
          sticky = "left",
          style  = list(background = "#f5f5f5")
        ),
        month_current = reactable::colDef(
          name   = "Operating Month",
          format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE),
          style  = list(background = "#f5f5f5", fontWeight = "bold", borderRight = "1px solid rgba(0, 0, 0, 0.1)"),
          sticky = "left"
        ),
        month_previous = reactable::colDef(
          name   = "Previous Month",
          format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE),
          style  = function(value, index) list(color = df$month_previous_col[index])
        ),
        three_months_average = reactable::colDef(
          name   = "Past 3 Months Average",
          format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE),
          style  = function(value, index) list(color = df$three_months_previous_col[index])
        ),
        six_months_average = reactable::colDef(
          name   = "Past 6 Months Average",
          format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE),
          style  = function(value, index) list(color = df$six_months_previous_col[index])
        ),
        color                     = reactable::colDef(show = FALSE),
        month_previous_col        = reactable::colDef(show = FALSE),
        three_months_previous_col = reactable::colDef(show = FALSE),
        six_months_previous_col   = reactable::colDef(show = FALSE)
      )
    )
}


#' Plot the Spend Percentage Comparison Table
#'
#' @inheritParams appPersonal::get_df_spend_comparison
#' @noRd
table_spend_comparison_perc <- function(date, df_transactions, df_earnings) {

  df <- get_df_spend_comparison(date, df_transactions, df_earnings)

  df |>
    dplyr::select(category, month_current, contains("change"), -contains("col"), color) |>
    reactable::reactable(
      defaultPageSize = 11,
      compact         = TRUE,
      highlight       = TRUE,

      columns = list(
        category = reactable::colDef(
          name   = "Category",
          cell   = reactablefmtr::pill_buttons(data = df, color_ref = "color"),
          width  = 130,
          sticky = "left",
          style  = list(background = "#f5f5f5")
        ),
        month_current = reactable::colDef(
          name   = "Operating Month",
          format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE),
          style  = list(background = "#f5f5f5", fontWeight = "bold", borderRight = "1px solid rgba(0, 0, 0, 0.1)"),
          sticky = "left"
        ),
        change_prev_month = reactable::colDef(
          name   = "Previous Month",
          format = reactable::colFormat(percent = TRUE, digits = 1),
          style  = function(value, index) style_spend_comparison_values_perc(value, index)
        ),
        change_three_months_avg = reactable::colDef(
          name   = "Past 3 Months Average",
          format = reactable::colFormat(percent = TRUE, digits = 1),
          style  = function(value, index) style_spend_comparison_values_perc(value, index)
        ),
        change_six_months_avg = reactable::colDef(
          name   = "Past 6 Months Average",
          format = reactable::colFormat(percent = TRUE, digits = 1),
          style  = function(value, index) style_spend_comparison_values_perc(value, index)
        ),
        color = reactable::colDef(show = FALSE)
      )
    )
}


# Data for the Spend & Assets (Perc) Change Cards ---------------------------

#' Prepare Data for the Expenses/Assets Cards
#'
#' @inheritParams appPersonal::get_df_spend_comparison
#' @noRd
get_df_expenses_assets_change <- function(date, df_transactions, df_earnings) {

  get_df_spend_comparison(date, df_transactions, df_earnings) |>
    dplyr::select(category, month_current, month_previous, three_months_average, six_months_average) |>
    dplyr::filter(category != "Remainder") |>
    dplyr::mutate(category = base::ifelse(category %in% c("Savings", "Investments"), "Assets", "Expenses")) |>
    dplyr::group_by(category) |>
    dplyr::reframe(dplyr::across(where(is.numeric), base::sum)) |>
    dplyr::mutate(
      change_previous = base::round(month_current - month_previous, 2),
      change_previous_three_avg = base::round(month_current - three_months_average, 2),
      change_previous_six_avg = base::round(month_current - six_months_average, 2),

      change_previous_perc = base::ifelse(month_previous == 0, 100, base::round(100 * (month_current / month_previous - 1), 1)),
      change_previous_three_avg_perc = base::ifelse(three_months_average == 0, 100, base::round(100 * (month_current / three_months_average - 1), 1)),
      change_previous_six_avg_perc = base::ifelse(six_months_average == 0, 100, base::round(100 * (month_current / six_months_average - 1), 1))
    )
}

