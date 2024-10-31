
# Code for the Interest Rates Over Time Plot ------------------------------


#' Plot the Loan Interest Rates Over Time
#'
#' @param df_historical_rpi Data with monthly historical RPI figures. See \code{appPersonal::df_historical_rpi} as an example.
#' @param df_loan_repays Data with monthly loan repayments. See \code{appPersonal::df_loan_repays} as an example.
#' @noRd
plot_loan_interest_rates <- function(df_historical_rpi, df_loan_repays) {

  df_historical_rpi |>
    dplyr::left_join(df_loan_repays, by = "date") |>
    dplyr::select(date, dplyr::contains("rate"), rpi) |>
    dplyr::mutate(rpi_march = as.numeric(ifelse(lubridate::month(date) == 3, rpi, NA))) |>
    tidyr::fill(rpi_march, .direction = "down") |>
    dplyr::mutate(rpi_max = ifelse(rpi_march >= rpi, rpi_march + 3, rpi + 3)) |>
    echarts4r::e_chart(x = date) |>
    echarts4r::e_line(
      serie  = interest_rate_ug,
      name   = "Plan 2",
      symbol = "none",
      color  = col_palette_deductions[col_palette_deductions$category == "Student Loan Plan 2",]$color,
      endLabel = list(
        show       = TRUE,
        formatter  = "{a}",
        color      = "inherit",
        fontWeight = "bold",
        offset     = c(0, -5)
      )
    ) |>
    echarts4r::e_line(
      serie  = interest_rate_pg,
      symbol = "none",
      name   = "Postgrad",
      color  = col_palette_deductions[col_palette_deductions$category == "Student Loan Postgrad",]$color,
      endLabel = list(
        show       = TRUE,
        formatter  = "{a}",
        color      = "inherit",
        fontWeight = "bold",
        offset     = c(0, 5)
      )
    ) |>
    echarts4r::e_line(
      serie     = rpi,
      symbol    = "none",
      color     = "black",
      name      = "RPI",
      lineStyle = list(width = 0.5),
      endLabel  = list(
        show       = TRUE,
        formatter  = "{a}",
        color      = "inherit",
        fontWeight = "bold"
      )
    ) |>
    echarts4r::e_line(
      serie     = rpi_max,
      symbol    = "none",
      name      = "max(RPI in March, RPI) + 3%",
      lineStyle = list(type = "dashed", width = 0.5),
      color     = "gray"
    ) |>
    echarts4r::e_mark_p(
      type = "area",
      serie_index = 1,
      data = list(
        list(xAxis = as.Date("2018-10-01")),
        list(xAxis = as.Date("2021-07-01"))
      ),
      itemStyle = list(
        color   = get_hex_colour_shade(col_palette_deductions[col_palette_deductions$category == "Student Loan Plan 2",]$color, 0.4),
        opacity = 0.2
      ),
      label = list(
        formatter = "Undergraduate Studies",
        position  = "top",
        align     = "center"
      )
    ) |>
    echarts4r::e_mark_p(
      type = "area",
      serie_index = 2,
      data = list(
        list(xAxis = as.Date("2021-10-01")),
        list(xAxis = as.Date("2022-10-01"))
      ),
      itemStyle = list(
        color   = get_hex_colour_shade(col_palette_deductions[col_palette_deductions$category == "Student Loan Postgrad",]$color, 0.4),
        opacity = 0.2
      ),
      label = list(
        formatter = "Postgraduate Studies",
        position  = "top",
        align     = "center"
      )
    ) |>
    echarts4r::e_tooltip(
      trigger        = "axis",
      valueFormatter = htmlwidgets::JS(
        "function(value) {
          return parseFloat(value) + '%';
        }"
      )
    ) |>
    echarts4r::e_y_axis(axisLabel = list(formatter = '{value}%')) |>
    echarts4r::e_legend(show = FALSE) |>
    echarts4r::e_theme("roma")
}
