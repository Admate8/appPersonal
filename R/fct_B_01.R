
# Data & Code for the Spend Over Time Plot --------------------------------



#' Prepare Spend Over Time Data
#'
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#' @param df_earnings Data with monthly earnings. See \code{appPersonal::df_earnings} as an example.
#'
#' @return Preprocessed data ready for the spend over time plot.
#' @noRd
df_spend_over_time <- function(df_transactions, df_earnings) {

  df_transactions |>
    # Sum spend by month-year and categories
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date_month, category) |>
    dplyr::summarise(spend = base::sum(value), .groups = "drop") |>
    # Join salary to calculate remainder after spend
    dplyr::left_join(
      df_earnings |> dplyr::select(date, monthly_net),
      by = dplyr::join_by(date_month == date)
    ) |>
    tidyr::pivot_wider(
      names_from  = category,
      values_from = spend,
      values_fill = 0L
    ) |>
    dplyr::rowwise() |>
    dplyr::mutate(all_spending = base::sum(dplyr::c_across(-c(date_month, monthly_net)))) |>
    dplyr::ungroup() |>
    dplyr::mutate(Remainder = ifelse(monthly_net - all_spending <= 0, 0, monthly_net - all_spending)) |>
    dplyr::select(-monthly_net, -all_spending) |>
    tidyr::pivot_longer(
      cols      = -date_month,
      names_to  = "category",
      values_to = "spend"
    ) |>
    dplyr::mutate(category = base::factor(category, levels = col_palette_categories$category))
}

#' Plot Spend Over Time
#'
#' @param date Any valid date of the form YYYY-MM-DD.
#' This becomes useful then the data becomes too large and we want to focus only
#' on the current year but still be able to see previous years. \code{startValue}
#' controls this behaviour.
#' @inheritParams appPersonal::df_spend_over_time
#'
#' @return Echart: plot spend over time.
#' @noRd
plot_spend_over_time <- function(date, df_transactions, df_earnings) {

  df_spend_over_time(df_transactions, df_earnings) |>
    dplyr::group_by(category) |>
    echarts4r::e_chart(x = date_month) |>
    echarts4r::e_bar(
      serie          = spend,
      barCategoryGap = "30%",
      barGap         = "-20%",
      itemStyle      = list(borderRadius = list(7, 7, 0, 0)),
      emphasis       = list(focus = "series")
    ) |>
    echarts4r::e_color(col_palette_categories$color) |>
    echarts4r::e_y_axis(
      formatter = echarts4r::e_axis_formatter(
        style    = "currency",
        digits   = 0,
        currency = "GBP"
      )
    ) |>
    echarts4r::e_x_axis(
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
            let current_date = new Date(params.value);
            return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
          }"
      )))
    ) |>
    echarts4r::e_tooltip(
      trigger        = "axis",
      valueFormatter = htmlwidgets::JS(
        "function(value) {
          return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
      ),
      axisPointer = list(
        type = "cross",
        label = list(formatter = htmlwidgets::JS(
          "function(params) {
            return parseFloat(params.value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
          }"
        ))
      )
    ) |>
    custom_legend() |>
    custom_datazoom(
      x_index = 0
      # Capture the whole year - shift the slider slightly before the beginning of the year
      # startValue = as.Date(paste0(lubridate::year(date) - 1, "-12-27"))
    ) |>
    echarts4r::e_grid(left = "15%") |>
    echarts4r::e_theme("roma")
}


