
# Data & Code for the Liabilities Waterfall Chart -------------------------


#' Prepare Data for the Waterfall Chart
#'
#' @param df_loan_repays Data with monthly loan repayments. See \code{appPersonal::df_loan_repays} as an example.
#' @noRd
get_df_loan_waterfall <- function(df_loan_repays) {

  df_loan_waterfall <- df_loan_repays |>
    tidyr::replace_na(list(outlay_pg = 0L, interest_pg = 0L, repays_pg = 0L)) |>
    dplyr::mutate(
      outlay_ug_cum   = cumsum(outlay_ug),
      outlay_pg_cum   = cumsum(outlay_pg),
      interest_ug_cum = cumsum(interest_ug),
      interest_pg_cum = cumsum(interest_pg),
      repays_ug_cum   = cumsum(repays_ug),
      repays_pg_cum   = cumsum(repays_pg)
    ) |>
    dplyr::slice(dplyr::n()) |>
    dplyr::select(dplyr::contains("cum"), balance_ug_x = balance_ug, balance_pg_x = balance_pg) |>
    tidyr::pivot_longer(dplyr::everything()) |>
    dplyr::mutate(loan_type = sub(".*_([^_]+)_.*", "\\1", name)) |>
    dplyr::mutate(
      name = dplyr::case_when(
        grepl("outlay", name) ~ "Outlay",
        grepl("interest", name) ~ "Interest",
        grepl("repays", name) ~ "Repayments",
        TRUE ~ "Total Balance"
      ),
      loan_type = ifelse(loan_type == "ug", "Plan 2", "Postgrad"),
      value     = abs(value)
    )

  # Reshape and add blank placeholders
  ph_ug_interest <- df_loan_waterfall |>
    dplyr::filter(name == "Outlay" & loan_type == "Plan 2") |>
    dplyr::pull(value)
  ph_pg_interest <- df_loan_waterfall |>
    dplyr::filter(name == "Outlay" & loan_type == "Postgrad") |>
    dplyr::pull(value)
  ph_ug_repays   <- df_loan_waterfall |>
    dplyr::filter(name == "Total Balance" & loan_type == "Plan 2") |>
    dplyr::pull(value)
  ph_pg_repays   <- df_loan_waterfall |>
    dplyr::filter(name == "Total Balance" & loan_type == "Postgrad") |>
    dplyr::pull(value)

  df_loan_waterfall$placeholder <- c(0, 0, ph_ug_interest, ph_pg_interest, ph_ug_repays, ph_pg_repays, 0, 0)

  return(df_loan_waterfall)
}


#' Plot Liabilities Waterfall Chart
#'
#' @param @inheritParams appPersonal::get_df_loan_waterfall
#' @noRd
plot_liabilities_waterfall <- function(df_loan_repays) {

  df_loan_waterfall <- get_df_loan_waterfall(df_loan_repays)

  dplyr::left_join(
    x = df_loan_waterfall |>
      dplyr::filter(loan_type == "Plan 2") |>
      dplyr::rename(value_ug = value, placeholder_ug = placeholder) |>
      dplyr::select(-loan_type),
    y = df_loan_waterfall |>
      dplyr::filter(loan_type == "Postgrad") |>
      dplyr::rename(value_pg = value, placeholder_pg = placeholder) |>
      dplyr::select(-loan_type),
    by = "name"
  ) |>
    echarts4r::e_chart(x = name) |>
    echarts4r::e_bar(
      serie = placeholder_ug,
      stack = "stack1",
      itemStyle = list(borderColor = "transparent", color = "transparent"),
      emphasis  = list(borderColor = "transparent", color = "transparent"),
      legend    = list(show = FALSE),
      tooltip   = list(show = FALSE)
    ) |>
    echarts4r::e_bar(
      serie = value_ug,
      name  = "Plan 2",
      stack = "stack1",
      color = col_palette_deductions[col_palette_deductions$category == "Student Loan Plan 2",]$color,
      label = list(
        show      = TRUE,
        formatter = htmlwidgets::JS(
          "function (params) {
          return parseFloat(params.value[1]).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
        ),
        fontWeight = "bold",
        color      = "white"
      )
    ) |>
    echarts4r::e_bar(
      serie = placeholder_pg,
      stack = "stack2",
      itemStyle = list(borderColor = "transparent", color = "transparent"),
      emphasis  = list(borderColor = "transparent", color = "transparent"),
      legend    = list(show = FALSE),
      tooltip   = list(show = FALSE)
    ) |>
    echarts4r::e_bar(
      serie = value_pg,
      name  = "Postgrad",
      stack = "stack2",
      color = col_palette_deductions[col_palette_deductions$category == "Student Loan Postgrad",]$color,
      label = list(
        show      = TRUE,
        formatter = htmlwidgets::JS(
          "function (params) {
          return parseFloat(params.value[1]).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
        ),
        fontWeight = "bold",
        color      = "white"
      )
    ) |>
    echarts4r::e_tooltip(
      trigger = "axis",
      axisPointer = list(type = "shadow"),
      valueFormatter = htmlwidgets::JS(
        "function(value) {
          return parseFloat(value).toLocaleString('en-GB', {style: 'currency', currency: 'GBP'});
        }"
      )
    ) |>
    echarts4r::e_x_axis(splitLine = list(show = FALSE)) |>
    echarts4r::e_y_axis(scale = TRUE, formatter = echarts4r::e_axis_formatter(
      style    = "currency",
      currency = "GBP"
    )) |>
    echarts4r::e_legend(
      top        = "1%",
      itemWidth  = 30,
      backgroundColor = "rgba(240, 240, 240)",
      borderRadius    = 10,
      textStyle       = list(fontSize = 14)
    ) |>
    echarts4r::e_theme("roma")
}
