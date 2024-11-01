
# Code for the Earnings and Deductions Over Time -------------------


#' Helper Function to Draw Custom e_bar Series
#'
#' @param ... Any other echarts4r::e_bar argument.
#' @param name Name of the serie, as it appears on the plot.
#' @param col_name Must be one of the name present in \code{col_palette_deductions}.
#' @param index Either 0 or 1; y-axis corresponding to the serie.
#'
#' @return echarts4r::e_bar object.
#' @noRd
draw_bar_serie_01 <- function(..., name, col_name, index = 0) {
  if (index == 0) {
    tooltip <- list(valueFormatter = htmlwidgets::JS(
      "function (value) {
          return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
      }"
    ))
    factor = 0
    stack  = "stack_1"
  }
  else {
    tooltip <- list(valueFormatter = htmlwidgets::JS(
      "function(value) {
        return parseFloat(value) + '%';
      }"
    ))
    factor = 0.4
    stack  = "stack_2"
  }

  echarts4r::e_bar(
    name     = name,
    emphasis = list(focus = "series"),
    stack    = stack,
    color    = get_hex_colour_shade(col_palette_deductions[col_palette_deductions$category == col_name,]$color, factor = factor),
    y_index  = index,
    tooltip  = tooltip,
    ...
  )
}

#' Plot Earnings Over Time
#'
#' @param date Any valid date of the form YYYY-MM-DD.
#' @param df_earnings Data with monthly earnings. See \code{appPersonal::df_earnings} as an example.
#'
#' @noRd
plot_earnings_over_time <- function(date, df_earnings) {

  df_earnings |>
    dplyr::mutate(
      net_perc         = monthly_net / monthly_gross,
      tax_perc         = tax_deduction / monthly_gross,
      pension_perc     = pension_deduction / monthly_gross,
      ni_perc          = national_insurance_deduction / monthly_gross,
      sl_plan2_perc    = student_loan_plan_2_deduction / monthly_gross,
      sl_postgrad_perc = student_loan_postgrad_deduction / monthly_gross,
      dplyr::across(contains("perc"), function(x) base::round(100 * x, 1))
    ) |>
    echarts4r::e_chart(x = date) |>
    echarts4r::e_scatter(
      serie      = monthly_gross,
      name       = "Gross Earnings",
      emphasis   = list(focus = "series"),
      symbol     = "diamond",
      symbolSize = 10,
      color      = col_palette_deductions[col_palette_deductions$category == "Gross Earnings",]$color
    ) |>
    draw_bar_serie_01(serie = monthly_net, name = "Net Earnings", col_name = "Net Earnings") |>
    echarts4r::e_mark_line(
      data    = list(type = "average", name = "Total Average"),
      title   = "",
      tooltip = list(valueFormatter = htmlwidgets::JS(
        "function (value) {
          return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
      ))
    )  |>
    draw_bar_serie_01(serie = net_perc, name = "Net Earnings (%)", col_name = "Net Earnings", index = 1) |>
    draw_bar_serie_01(serie = tax_deduction, name = "Tax", col_name = "Tax") |>
    draw_bar_serie_01(serie = tax_perc, name = "Tax (%)", col_name = "Tax", index = 1) |>
    draw_bar_serie_01(serie = pension_deduction, name = "Pension", col_name = "Pension") |>
    draw_bar_serie_01(serie = pension_perc, name = "Pension (%)", col_name = "Pension", index = 1) |>
    draw_bar_serie_01(serie = national_insurance_deduction, name = "National Insurance", col_name = "National Insurance") |>
    draw_bar_serie_01(serie = ni_perc, name = "National Insurance (%)", col_name = "National Insurance", index = 1) |>
    draw_bar_serie_01(serie = student_loan_plan_2_deduction, name = "Student Loan Plan 2", col_name = "Student Loan Plan 2") |>
    draw_bar_serie_01(serie = sl_plan2_perc, name = "Student Loan Plan 2 (%)", col_name = "Student Loan Plan 2", index = 1) |>
    draw_bar_serie_01(serie = student_loan_postgrad_deduction, name = "Student Loan Postgrad", col_name = "Student Loan Postgrad") |>
    draw_bar_serie_01(serie = sl_postgrad_perc, name = "Student Loan Postgrad (%)", col_name = "Student Loan Postgrad", index = 1) |>
    echarts4r::e_tooltip() |>
    echarts4r::e_y_axis(
      index = 0,
      name  = "Nominal\nBreakdown",
      nameTextStyle = list(align = "left"),
      formatter = echarts4r::e_axis_formatter(
        style    = "currency",
        currency = "GBP"
      )
    ) |>
    echarts4r::e_y_axis(
      index = 1,
      max   = 100.1,
      name  = "Percentage of Gross\nEarnings Breakdown",
      nameTextStyle = list(align = "right"),
      axisLabel     = list(formatter = '{value}%')
    ) |>
    custom_legend(itemGap = 17) |>
    custom_datazoom(
      x_index = 0,
      # Capture the whole year - shift the slider slightly before the beginning of the year
      startValue = as.Date(paste0(lubridate::year(date) - 2, "-12-27"))
    ) |>
    echarts4r::e_grid(left = "22%") |>
    echarts4r::e_theme("roma")
}

