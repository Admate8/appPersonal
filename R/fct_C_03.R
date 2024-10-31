
# Code for the Liabilities Over Time Plot ---------------------------------


#' Plot Liabilities Over Time
#'
#' @param df_loan_repays Data with monthly loan repayments. See \code{appPersonal::df_loan_repays} as an example.
#' @noRd
plot_loans_over_time <- function(df_loan_repays) {

  df_loan_repays |>
    echarts4r::e_chart(x = date) |>

    # Balance: UG - top chart
    echarts4r::e_line(
      serie    = balance_ug,
      symbol   = "none",
      name     = "Plan 2 Loan Balance",
      color    = get_hex_colour_shade(col_palette_deductions[col_palette_deductions$category == "Student Loan Plan 2",]$color, 0),
      y_index  = 1,
      x_index  = 1,
      endLabel = list(
        show       = TRUE,
        fontWeight = "bolder",
        fontSize   = 15,
        formatter  = htmlwidgets::JS(
          "function (params) {
            return parseFloat(params.value[1]).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
        )
      )
    ) |>

    # Balance: PG - top chart
    echarts4r::e_line(
      serie    = balance_pg,
      symbol   = "none",
      name     = "Postgrad Loan Balance",
      color    = get_hex_colour_shade(col_palette_deductions[col_palette_deductions$category == "Student Loan Postgrad",]$color, 0),
      y_index  = 1,
      x_index  = 1,
      endLabel = list(
        show       = TRUE,
        fontWeight = "bolder",
        #fontSize   = 15,
        formatter  = htmlwidgets::JS(
          "function (params) {
            return parseFloat(params.value[1]).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
        )
      )
    ) |>

    # Interest & Repayments: UG - bottom chart
    echarts4r::e_bar(
      serie = interest_ug,
      name  = "Plan 2 Interest Accrued",
      stack = "stack1",
      color = "#AF125A"
    ) |>
    echarts4r::e_bar(
      serie = repays_ug,
      name  = "Plan 2 Repayments",
      stack = "stack1",
      color = "#334139"
    ) |>

    # Interest & Repayments: UG - bottom chart
    echarts4r::e_bar(
      serie = interest_pg,
      name  = "Postgrad Interest Accrued",
      stack = "stack2",
      color = get_hex_colour_shade("#AF125A", 0.3)
    ) |>
    echarts4r::e_bar(
      serie = repays_pg,
      name  = "Postgrad Repayments",
      stack = "stack2",
      color = get_hex_colour_shade("#334139", 0.3)
    ) |>

    echarts4r::e_grid(left = "25%", height = "33%") |>
    echarts4r::e_grid(left = "25%", height = "33%", top = "53%") |>
    echarts4r::e_y_axis(
      gridIndex     = 0,
      index         = 1,
      name          = "Total Loan Balance",
      nameTextStyle = list(align = "left", fontWeight = "bold"),
      formatter     = echarts4r::e_axis_formatter(
        style    = "currency",
        currency = "GBP"
      )
    ) |>
    echarts4r::e_y_axis(
      gridIndex     = 1,
      index         = 0,
      name          = "Interest Accrued & Repayments",
      nameTextStyle = list(align = "left", fontWeight = "bold"),
      formatter     = echarts4r::e_axis_formatter(
        style    = "currency",
        currency = "GBP"
      )
    ) |>
    echarts4r::e_x_axis(gridIndex = 1, index = 0) |>
    echarts4r::e_x_axis(
      gridIndex   = 0,
      index       = 1,
      axisLine    = list(onZero = FALSE),
      axisTick    = list(show = FALSE),
      splitLine   = list(show = FALSE),
      axisLabel   = list(show = FALSE),
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
            return ''
        }"
      )))
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
    echarts4r::e_axis_pointer(link = list(xAxisIndex = c(0, 1))) |>
    custom_datazoom(xAxisIndex = c(0, 1), height = 20) |>
    custom_legend(itemGap = 20) |>
    echarts4r::e_theme("roma")
}
