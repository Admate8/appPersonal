
# Data & Code for the Percentage Spend Over Time Plot ---------------------


#' Prepare Spend Over Time Percentage Data
#'
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#' @param df_earnings Data with monthly earnings. See \code{appPersonal::df_earnings} as an example.
#'
#' @return Preprocessed data ready for the spend over time plot.
#' @noRd
get_df_spend_over_time_perc <- function(df_transactions, df_earnings) {

  df_transactions |>
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date_month, category) |>
    dplyr::summarise(spend = base::sum(value), .groups = "drop") |>
    dplyr::left_join(
      df_earnings |> dplyr::select(date, monthly_net),
      by = dplyr::join_by(date_month == date)
    ) |>
    dplyr::mutate(percentage = round(100 * spend / monthly_net, 1)) |>
    dplyr::select(date_month, category, percentage) |>
    tidyr::pivot_wider(
      names_from  = category,
      values_from = percentage,
      values_fill = 0L
    ) |>
    dplyr::rowwise() |>
    dplyr::mutate(all_spending = base::sum(dplyr::c_across(-date_month))) |>
    dplyr::ungroup() |>
    dplyr::mutate(Remainder = ifelse(100 - all_spending <= 0, 0, 100 - all_spending)) |>
    dplyr::select(-all_spending) |>
    tidyr::pivot_longer(
      cols      = -date_month,
      names_to  = "category",
      values_to = "spend"
    ) |>
    dplyr::mutate(category = base::factor(category, levels = col_palette_categories$category))
}

#' Plot Spend Over Time Percentages
#'
#' @param date Any valid date of the form YYYY-MM-DD.
#' This becomes useful then the data becomes too large and we want to focus only
#' on the current year but still be able to see previous years. \code{startValue}
#' controls this behaviour.
#' @inheritParams appPersonal::df_spend_over_time_perc
#'
#' @return Echart: plot spend over time.
#' @noRd
plot_spend_over_time_perc <- function(date, df_transactions, df_earnings) {

  get_df_spend_over_time_perc(df_transactions, df_earnings) |>
    dplyr::group_by(category) |>
    echarts4r::e_chart(x = date_month) |>
    echarts4r::e_bar(
      serie    = spend,
      stack    = "bar_stack",
      emphasis = list(focus = "series")
    ) |>
    echarts4r::e_color(col_palette_categories$color) |>
    echarts4r::e_mark_line(
      data   = list(yAxis = 20),
      title  = "Save/Invest",
      silent = TRUE
    ) |>
    echarts4r::e_tooltip(
      trigger        = "item",
      valueFormatter = htmlwidgets::JS("function(value) {return parseFloat(value) + '%';}")
    ) |>
    echarts4r::e_y_axis(axisLabel = list(formatter = '{value}%')) |>
    custom_legend(itemGap = 20) |>
    custom_datazoom(
      x_index = 0
      # Capture the whole year - shift the slider slightly before the beginning of the year
      # startValue = as.Date(paste0(lubridate::year(date) - 1, "-12-27"))
    ) |>
    echarts4r::e_grid(left = "15%") |>
    echarts4r::e_theme("roma")
}
