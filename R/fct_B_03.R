
# Data & Code for the Income Allocation plot ------------------------------


#' Prepare Data for the Monthly Allocations Plot
#'
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#' @param df_earnings Data with monthly earnings. See \code{appPersonal::df_earnings} as an example.
#'
#' @return Preprocessed data ready for the spend over time plot.
#' @noRd
get_df_monthly_allocation <- function(df_transactions, df_earnings) {

  df_earnings_over_time <- df_earnings |>
    dplyr::select(date_month = date, net_earnings = monthly_net)

  df_net_income_over_time <- df_transactions |>
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date_month) |>
    dplyr::summarise(value = base::sum(value), .groups = "drop") |>
    dplyr::left_join(
      df_earnings |> dplyr::select(date, monthly_net),
      by = dplyr::join_by(date_month == date)
    ) |>
    dplyr::mutate(net_income = monthly_net - value, .keep = "unused")

  df_allocations_over_time <- df_transactions |>
    dplyr::mutate(
      date_month = lubridate::floor_date(date, unit = "month"),
      category = base::ifelse(category %in% c("Savings", "Investments"), "assets", "expenses")
    ) |>
    dplyr::group_by(date_month, category) |>
    dplyr::summarise(value = base::sum(value), .groups = "drop") |>
    tidyr::pivot_wider(
      names_from  = category,
      values_from = value,
      values_fill = 0L
    )

  df_allocations_per_month_ready <- df_earnings_over_time |>
    dplyr::inner_join(df_allocations_over_time, by = dplyr::join_by(date_month)) |>
    dplyr::inner_join(df_net_income_over_time, by = dplyr::join_by(date_month))

  return(df_allocations_per_month_ready)
}


#' Plot Income Allocations Over Time
#'
#' @param date Any valid date of the form YYYY-MM-DD.
#' This becomes useful then the data becomes too large and we want to focus only
#' on the current year but still be able to see previous years. \code{startValue}
#' controls this behaviour.
#' @inheritParams appPersonal::get_df_monthly_allocation
#'
#' @return Echart: plot spend over time.
#' @noRd
plot_allocations_over_time <- function(date, df_transactions, df_earnings) {

  get_df_monthly_allocation(df_transactions, df_earnings) |>
    echarts4r::e_chart(x = date_month) |>
    echarts4r::e_bar(
      serie    = net_earnings,
      name     = "Net Earnings",
      stack    = "stack_1",
      emphasis = list(focus = "series")
    ) |>
    echarts4r::e_bar(
      serie    = expenses,
      name     = "Expenses",
      stack    = "stack_2",
      emphasis = list(focus = "series")
    ) |>
    echarts4r::e_bar(
      serie    = assets,
      name     = "Assets",
      stack    = "stack_2",
      emphasis = list(focus = "series")
    ) |>
    echarts4r::e_bar(
      serie    = net_income,
      name     = "Net Income",
      stack    = "stack_2",
      emphasis = list(focus = "series")
    ) |>
    echarts4r::e_color(col_palette_categories_wider$color) |>
    echarts4r::e_y_axis(
      formatter = echarts4r::e_axis_formatter(
        style    = "currency",
        digits   = 0,
        currency = "GBP"
      )
    ) |>
    echarts4r::e_tooltip(
      trigger = "axis",
      valueFormatter = htmlwidgets::JS(
        "function(value) {
          return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
      ),
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
          let current_date = new Date(params.value);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        }"
      )))
    ) |>
    custom_legend(itemGap = 20) |>
    custom_datazoom(
      x_index = 0
      # Capture the whole year - shift the slider slightly before the beginning of the year
      # startValue = as.Date(paste0(lubridate::year(date) - 1, "-12-27"))
    ) |>
    echarts4r::e_grid(left = "15%") |>
    echarts4r::e_theme("roma")
}
