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
}
