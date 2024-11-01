
# Code for the Earnings & Deductions Calculator Plot ----------------------


#' Helper Function to Draw Custom e_line Series
#'
#' @param ... Any other echarts4r::e_line argument.
#' @param name Name of the serie, as it appears on the plot.
#' @param col_name Must be one of the name present in col_palette_deductions.
#' @param index Either 0 or 1; y-axis corresponding to the serie.
#'
#' @return echarts4r::e_line object
#' @noRd
draw_line_serie_01 <- function(..., name, col_name, index = 0) {
  if (index == 0) {
    tooltip <- list(valueFormatter = htmlwidgets::JS(
      "function (value) {
        return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
      }"
    ))
    factor  <- 0
    type    <- "solid"
    width   <- 2
  }
  else {
    tooltip <- list(valueFormatter = htmlwidgets::JS(
      "function(value) {
        return parseFloat(value) + '%';
      }"
    ))
    factor  <- 0.4
    type    <- "dashed"
    width   <- 1
  }

  echarts4r::e_line(
    name      = name,
    symbol    = "none",
    lineStyle = list(type = type, width = width),
    color     = get_hex_colour_shade(col_palette_deductions[col_palette_deductions$category == col_name,]$color, factor = factor),
    y_index   = index,
    tooltip   = tooltip,
    ...
  )
}


#' Plot the Income Calculator Breakdown
#'
#' @inheritParams appPersonal::get_df_income_calculator
#'
#' @return echart line / stacked area plot.
#' @noRd
plot_deductions_calculator <- function(
    annual_gross_earnings = base::seq(1000, 120000, 50),
    scaling_factor        = 0,
    period                = "month",
    alpha                 = TRUE,
    penstion_contr        = 0.04,
    tax_allowance         = 12570,
    ni_allowance          = 12570,
    slp2_allowance        = 27295,
    slpgrd_allowance      = 21000
) {
  if (period == "year") name_y_axis <- "Annual Gross\nEarnings"
  else if (period == "month") name_y_axis <- "Monthly Gross\nEarnings"
  else name_y_axis <- "Weekly Gross\nEarnings"

  get_df_income_calculator(
    annual_gross_earnings = annual_gross_earnings,
    scaling_factor        = scaling_factor,
    period                = period,
    alpha                 = alpha,
    penstion_contr        = penstion_contr,
    tax_allowance         = tax_allowance,
    ni_allowance          = ni_allowance,
    slp2_allowance        = slp2_allowance,
    slpgrd_allowance      = slpgrd_allowance
  ) |>
    dplyr::mutate(
      Gross_annual = dplyr::case_when(
        period == "year" ~ `Gross Earnings`,
        period == "month" ~ `Gross Earnings` * 12,
        period == "week" ~ `Gross Earnings` * 52.1429
      ),
      net_perc         = `Net Earnings` / `Gross Earnings`,
      tax_perc         = Tax / `Gross Earnings`,
      pension_perc     = Pension / `Gross Earnings`,
      ni_perc          = `National Insurance` / `Gross Earnings`,
      sl_plan2_perc    = `Student Loan Plan 2` / `Gross Earnings`,
      sl_postgrad_perc = `Student Loan Postgrad` / `Gross Earnings`,
      dplyr::across(contains("perc"), function(x) base::round(100 * x, 1))
    ) |>
    dplyr::mutate(Gross_annual = base::as.character(Gross_annual)) |>
    echarts4r::e_chart(x = Gross_annual) |>
    draw_line_serie_01(serie = `Gross Earnings`, name = "Gross Earnings", col_name = "Gross Earnings") |>
    draw_line_serie_01(serie = Pension, name = "Pension", col_name = "Pension") |>
    draw_line_serie_01(serie = pension_perc, name = "Pension (%)", col_name = "Pension", index = 1, stack = "stack", areaStyle = list(opacity = 0.3)) |>
    draw_line_serie_01(serie = `National Insurance`, name = "National Insurance", col_name = "National Insurance") |>
    draw_line_serie_01(serie = ni_perc, name = "National Insurance (%)", col_name = "National Insurance", index = 1, stack = "stack", areaStyle = list(opacity = 0.3)) |>
    draw_line_serie_01(serie = Tax, name = "Tax", col_name = "Tax") |>
    draw_line_serie_01(serie = tax_perc, name = "Tax (%)", col_name = "Tax", index = 1, stack = "stack", areaStyle = list(opacity = 0.3)) |>
    draw_line_serie_01(serie = `Student Loan Plan 2`, name = "Student Loan Plan 2", col_name = "Student Loan Plan 2") |>
    draw_line_serie_01(serie = sl_plan2_perc, name = "Student Loan Plan 2 (%)", col_name = "Student Loan Plan 2", index = 1, stack = "stack", areaStyle = list(opacity = 0.3)) |>
    draw_line_serie_01(serie = `Student Loan Postgrad`, name = "Student Loan Postgrad", col_name = "Student Loan Postgrad") |>
    draw_line_serie_01(serie = sl_postgrad_perc, name = "Student Loan Postgrad (%)", col_name = "Student Loan Postgrad", index = 1, stack = "stack", areaStyle = list(opacity = 0.3)) |>
    draw_line_serie_01(serie = `Net Earnings`, name = "Net Earnings", col_name = "Net Earnings") |>
    draw_line_serie_01(serie = net_perc, name = "Net Earnings (%)", col_name = "Net Earnings", index = 1, stack = "stack", areaStyle = list(opacity = 0.3)) |>
    #echarts4r::e_mark_line(data = list(xAxis = "56000"), lineStyle = list(color = "gray"), silent = TRUE, title = base::paste0("Taxable Income Reaches ",  "\U00A3",  "50,270"), title_position = "middle") |>
    echarts4r::e_y_axis(
      name          = name_y_axis,
      nameTextStyle = list(align = "left"),
      formatter     = echarts4r::e_axis_formatter(
        style    = "currency",
        currency = "GBP"
      )
    ) |>
    echarts4r::e_y_axis(
      index = 1,
      max   = 100.1,
      name  = "Percentage of\nGross Earnings",
      nameTextStyle = list(align = "right"),
      axisLabel     = list(formatter = '{value}%')
    ) |>
    echarts4r::e_x_axis(
      name    = "Annual Gross Earnings",
      nameGap = 30,
      nameLocation  = "middle",
      nameTextStyle = list(fontWeight = "bold"),
      formatter     = echarts4r::e_axis_formatter(
        style    = "currency",
        currency = "GBP"
      )
    ) |>
    echarts4r::e_tooltip(
      trigger     = "axis",
      axisPointer = list(label = list(precision = 0, formatter = htmlwidgets::JS(
        "function(params) {
          return 'Annual Gross Earnings: \U00A3' + parseFloat(params.value).toLocaleString();
        }"
      )))
    ) |>
    custom_legend(itemGap = 17) |>
    echarts4r::e_grid(left = "22%") |>
    echarts4r::e_theme("roma")
}
