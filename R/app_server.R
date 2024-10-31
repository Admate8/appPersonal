#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  # Tab B: Spend ----
  output$plot_allocations_over_time <- echarts4r::renderEcharts4r(plot_allocations_over_time(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings))
  output$plot_spend_over_time       <- echarts4r::renderEcharts4r(plot_spend_over_time(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings))
  output$plot_spend_over_time_perc  <- echarts4r::renderEcharts4r(plot_spend_over_time_perc(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings))

  output$table_spend_comparison      <- reactable::renderReactable(table_spend_comparison(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings))
  output$table_spend_comparison_perc <- reactable::renderReactable(table_spend_comparison_perc(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings))

  mod_B_01_server(
    id = "expenses_change", "expenses",
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Expenses") |> dplyr::pull(change_previous),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Expenses") |> dplyr::pull(change_previous_three_avg),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Expenses") |> dplyr::pull(change_previous_six_avg),
    "currency", shiny::icon("money-bill-wave")
  )
  mod_B_01_server(
    id = "assets_change", "assets",
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Assets") |> dplyr::pull(change_previous),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Assets") |> dplyr::pull(change_previous_three_avg),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Assets") |> dplyr::pull(change_previous_six_avg),
    "currency", shiny::icon("piggy-bank")
  )
  mod_B_01_server(
    id = "expenses_change_perc", "expenses",
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Expenses") |> dplyr::pull(change_previous_perc),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Expenses") |> dplyr::pull(change_previous_three_avg_perc),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Expenses") |> dplyr::pull(change_previous_six_avg_perc),
    "percentage", shiny::icon("money-bill-wave")
  )
  mod_B_01_server(
    id = "assets_change_perc", "assets",
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Assets") |> dplyr::pull(change_previous_perc),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Assets") |> dplyr::pull(change_previous_three_avg_perc),
    get_df_expenses_assets_change(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings) |> dplyr::filter(category == "Assets") |> dplyr::pull(change_previous_six_avg_perc),
    "percentage", shiny::icon("piggy-bank")
  )

  output$plot_spend_breakdown <- plotly::renderPlotly(
    get_df_spend_breakdown(lubridate::my(input$select_B_month), appPersonal::df_transactions) |>
      plot_spend_breakdown()
  )
  output$plot_spend_gauge_chart_spend <- echarts4r::renderEcharts4r({
    data    <- get_df_spend_gauge(lubridate::my(input$select_B_month), appPersonal::df_transactions)
    value   <- data[data$type == "Total Spend" & data$name == "selected",]$spend
    average <- data[data$type == "Total Spend" & data$name == "average",]$spend
    plot_spend_gauge_chart(value, "Total Expenses", average, "green", "orange", "red")
  })
  output$plot_spend_gauge_chart_assets <- echarts4r::renderEcharts4r({
    data    <- get_df_spend_gauge(lubridate::my(input$select_B_month), appPersonal::df_transactions)
    value   <- data[data$type == "Total Assets" & data$name == "selected",]$spend
    average <- data[data$type == "Total Assets" & data$name == "average",]$spend
    plot_spend_gauge_chart(value, "Total Assets", average, "red", "orange", "green")
  })
  output$table_biggest_spend       <- reactable::renderReactable({table_spend_biggest_spend(lubridate::my(input$select_B_month), appPersonal::df_transactions)})
  output$table_most_frequent_spend <- reactable::renderReactable({table_spend_most_often(lubridate::my(input$select_B_month), appPersonal::df_transactions)})


  # Tab C: Earnings ----
  output$plot_earnings_over_time <- echarts4r::renderEcharts4r(plot_earnings_over_time(golem::get_golem_options("operating_month"), appPersonal::df_earnings))
  observeEvent(input$select_C_loans_view, {
    if (input$select_C_loans_view == "loans_balance")    plot_to_draw <- plot_liabilities_waterfall(appPersonal::df_loan_repays)
    else if (input$select_C_loans_view == "loan_change") plot_to_draw <- plot_loans_over_time(appPersonal::df_loan_repays)
    else                                                 plot_to_draw <- plot_loan_interest_rates(appPersonal::df_historical_rpi, appPersonal::df_loan_repays)

    output$plot_liabilities <- echarts4r::renderEcharts4r(plot_to_draw)
  })
  output$table_earnings_check    <- reactable::renderReactable({table_earnings_check(lubridate::my(input$select_C_month), appPersonal::df_earnings)})
}
