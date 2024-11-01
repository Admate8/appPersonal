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
  # Open the annual allowance settings model on the button click
  # "Remember" the settings on the modal exit
  observeEvent(input$alowances_settings, {
    if (!is.null(input$set_tax_allowance))    shinyWidgets::updateCurrencyInput(session = session, "set_tax_allowance", value = input$set_tax_allowance)
    if (!is.null(input$set_ni_allowance))     shinyWidgets::updateCurrencyInput(session = session, "set_ni_allowance", value = input$set_ni_allowance)
    if (!is.null(input$set_slp2_allowance))   shinyWidgets::updateCurrencyInput(session = session, "set_slp2_allowance", value = input$set_slp2_allowance)
    if (!is.null(input$set_slpgrd_allowance)) shinyWidgets::updateCurrencyInput(session = session, "set_slpgrd_allowance", value = input$set_slpgrd_allowance)
    if (!is.null(input$is_alpha))             shinyWidgets::updateMaterialSwitch(session = session, "is_alpha", value = input$is_alpha)
    if (!is.null(input$set_pension_contr))    shinyWidgets::updateCurrencyInput(session = session, "set_pension_contr", value = input$set_pension_contr)
    if (!is.null(input$set_scaling_factor))   shinyWidgets::updateCurrencyInput(session = session, "set_scaling_factor", value = input$set_scaling_factor)

    showModal(set_allowances_modal())
  })
  # Restore the default allowance settings on the button click
  observeEvent(input$reset_allowances, {
    shinyWidgets::updateCurrencyInput(session = session, "set_tax_allowance", value = 12570)
    shinyWidgets::updateCurrencyInput(session = session, "set_ni_allowance", value = 12570)
    shinyWidgets::updateCurrencyInput(session = session, "set_slp2_allowance", value = 27288)
    shinyWidgets::updateCurrencyInput(session = session, "set_slpgrd_allowance", value = 21000)
    shinyWidgets::updateMaterialSwitch(session = session, "is_alpha", value = TRUE)
    shinyWidgets::updateCurrencyInput(session = session, "set_pension_contr", value = 0.04)
    shinyWidgets::updateCurrencyInput(session = session, "set_scaling_factor", value = 0)
  })
  # Validate user's input
  iv_gross <- shinyvalidate::InputValidator$new()
  iv_gross$add_rule("gross_annual_earnings", function(value) {if (!is.numeric(value) || value <= 1000) paste0("Must be greater than \u00A3", scales::comma(1000))})
  iv_gross$enable()
  iv <- shinyvalidate::InputValidator$new()
  iv$add_rule("set_tax_allowance",    function(value) {if (!is.numeric(value) || value < 0) paste0("Must be \u2265 \u00A3", "0")})
  iv$add_rule("set_ni_allowance",     function(value) {if (!is.numeric(value) || value < 0) paste0("Must be \u2265 \u00A3", "0")})
  iv$add_rule("set_slp2_allowance",   function(value) {if (!is.numeric(value) || value < 0) paste0("Must be \u2265 \u00A3", "0")})
  iv$add_rule("set_slpgrd_allowance", function(value) {if (!is.numeric(value) || value < 0) paste0("Must be \u2265 \u00A3", "0")})
  iv$add_rule("set_pension_contr",    function(value) {if (!is.numeric(value) || value < 0 || value >= 1) "Must be between 0% and 100%"})
  iv$add_rule("set_scaling_factor",   function(value) {if (!is.numeric(value) || value <= -1) "Must be \u2265 -100%"})
  # Remove the annual allowance settings modal on the button click if the input is valid
  observeEvent(input$save_allowances, {
    if (!iv$is_valid()) {
      iv$enable()
      showNotification("Set up valid allowances", type = "error")
    } else {
      removeModal()
    }
  })
  # Update the allowance settings on the button click
  selected_allowances <- eventReactive(c(input$alowances_settings, input$save_allowances), {
    # Restore default settings if the input is invalid
    if (!iv$is_valid()) {list(
      tax_allowance    = 12570,
      ni_allowance     = 12570,
      slp2_allowance   = 27288,
      slpgrd_allowance = 21000,
      is_alpha         = TRUE,
      pension_contr    = 0.04,
      scaling_factor   = 0
    )} else {list(
      tax_allowance    = input$set_tax_allowance,
      ni_allowance     = input$set_ni_allowance,
      slp2_allowance   = input$set_slp2_allowance,
      slpgrd_allowance = input$set_slpgrd_allowance,
      is_alpha         = input$is_alpha,
      pension_contr    = input$set_pension_contr,
      scaling_factor   = input$set_scaling_factor
    )}
  })
  # Restore default gross annual earnings if the input is invalid
  gross_annual_earnings          <- reactive({base::ifelse(input$gross_annual_earnings < 1000, 34963, input$gross_annual_earnings)})
  output$table_income_calculator <- reactable::renderReactable({table_income_calculator(
    gross_annual_earnings(),
    scaling_factor   = selected_allowances()[["scaling_factor"]],
    period           = input$select_calc_period,
    alpha            = selected_allowances()[["is_alpha"]],
    penstion_contr   = selected_allowances()[["pension_contr"]],
    tax_allowance    = selected_allowances()[["tax_allowance"]],
    ni_allowance     = selected_allowances()[["ni_allowance"]],
    slp2_allowance   = selected_allowances()[["slp2_allowance"]],
    slpgrd_allowance = selected_allowances()[["slpgrd_allowance"]]
  )})
  output$plot_deductions_calculator <- echarts4r::renderEcharts4r({plot_deductions_calculator(
    scaling_factor   = selected_allowances()[["scaling_factor"]],
    period           = input$select_calc_period,
    alpha            = selected_allowances()[["is_alpha"]],
    penstion_contr   = selected_allowances()[["pension_contr"]],
    tax_allowance    = selected_allowances()[["tax_allowance"]],
    ni_allowance     = selected_allowances()[["ni_allowance"]],
    slp2_allowance   = selected_allowances()[["slp2_allowance"]],
    slpgrd_allowance = selected_allowances()[["slpgrd_allowance"]]
  )})
  # Render the useful links modal on the button click
  observeEvent(input$deductions_links, {
    useful_links_modal()
  })
}
