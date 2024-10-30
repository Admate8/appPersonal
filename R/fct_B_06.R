
# Data & Code for the Spend Gauge Chart -----------------------------------


#' Prepare Data for the Spend Gauge Charts
#'
#' @param selected_month Date of the form "YYYY-MM-DD", e.g. "2023-01-01".
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#'
#' @return Data with details feeding into the spend gauge charts
#' @noRd
get_df_spend_gauge <- function(selected_month, df_transactions) {

  # Check if the data contains specified date
  if (selected_month %notin% lubridate::floor_date(df_transactions$date, unit = "month")) {
    base::stop(base::paste("Select date must be between", base::format(base::min(df_transactions$date), "%Y-%m"), "and", base::format(base::max(df_transactions$date), "%Y-%m")))
  }

  # Data frame summarising total spend and assets in the operating month
  df_totals_selected_month <- df_transactions |>
    dplyr::mutate(
      date_month = lubridate::floor_date(date, unit = "month"),
      type = base::ifelse(category %notin% c("Savings", "Investments"), "Total Spend", "Total Assets")
    ) |>
    dplyr::filter(date_month == selected_month) |>
    dplyr::group_by(type) |>
    dplyr::summarise(spend = base::round(base::sum(value), 2), .groups = "drop")

  # Data frame summarising total spend and assets in the previous 3 months
  df_totals_3m_average <- df_transactions |>
    dplyr::mutate(
      date_month = lubridate::floor_date(date, unit = "month"),
      type = base::ifelse(category %notin% c("Savings", "Investments"), "Total Spend", "Total Assets")
    ) |>
    dplyr::filter(dplyr::between(date_month, selected_month - base::months(3), selected_month - base::months(1))) |>
    dplyr::group_by(type) |>
    dplyr::summarise(spend = base::round(base::sum(value) / 3, 2), .groups = "drop")

  base::rbind(
    df_totals_selected_month |> dplyr::mutate(name = "selected"),
    df_totals_3m_average |> dplyr::mutate(name = "average")
  )
}


#' Plot the Spend Gauge Chart
#'
#' @param value Value shown in the chart.
#' @param title Title of the chart.
#' @param average Average value to be shown under the title.
#' @param first_color The first colour from the left.
#' @param second_color Middle colour.
#' @param third_color The last colour.
#'
#' @return Gauge echarts4r plot.
#' @noRd
plot_spend_gauge_chart <- function(value, title, average, first_color, second_color, third_color) {

  echarts4r::e_charts() |>
    echarts4r::e_gauge(
      value       = value,
      name        = base::paste0(title, "\n Last 3M Average: ", base::enc2utf8("\u00A3"), scales::comma(base::round(average, 2))),
      radius      = "100%",
      startAngle  = 180,
      endAngle    = 0,
      center      = list('50%', '70%'),
      min         = base::round(0.8 * average, -2),
      max         = base::round(1.2 * average, -2),
      splitNumber = 5,
      axisLine    = list(
        lineStyle = list(
          width = 10,
          color = list(
            list(0.85 * 0.5, first_color),
            list(1.15 * 0.5, second_color),
            list(1, third_color)
          )
        ),
        roundCap = TRUE
      ),
      axisLabel = list(
        distance  = -25,
        fontSize  = 10,
        formatter = htmlwidgets::JS(
          "function(value) {
            return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP', minimumFractionDigits: 0});
          }"
        )
      ),
      pointer = list(
        length       = "20%",
        width        = 3,
        offsetCenter = list(0, "-65%"),
        itemStyle    = list(color =  "auto")
      ),
      axisTick = list(
        distance  = -20,
        length    = 5,
        lineStyle = list(color = "auto", width = 1)
      ),
      splitLine = list(
        distance  = -20,
        length    = 5,
        lineStyle = list(color = "auto", width = 3)
      ),
      title  = list(offsetCenter = list(0, "-5%"), fontSize = 10),
      detail = list(
        fontSize       = 20,
        offsetCenter   = list(0, "-30%"),
        color          = "inherit",
        valueAnimation = TRUE,
        formatter      = htmlwidgets::JS(
          "function(value) {
            return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP', minimumFractionDigits: 2});
          }"
        )
      )
    )
}

