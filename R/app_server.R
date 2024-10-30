#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  # Tab B: Spend ----
  output$plot_spend_over_time       <- echarts4r::renderEcharts4r(plot_spend_over_time(golem::get_golem_options("operating_month"), appPersonal::df_transactions, appPersonal::df_earnings))
}
