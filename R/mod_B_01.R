#' B_01 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
mod_B_01_ui <- function(id){
  ns <- shiny::NS(id)
  uiOutput(ns("expenses_change"))
}

#' B_01 Server Functions
#'
#' @noRd
mod_B_01_server <- function(
    id,
    expenses_or_assets = c("expenses", "assets"),
    change_previous,
    change_previous_three_avg,
    change_previous_six_avg,
    prefix_or_suffix = c("currency", "percentage"),
    icon
) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    stopifnot(is.numeric(change_previous), is.numeric(change_previous_three_avg), is.numeric(change_previous_six_avg), methods::is(icon, "shiny.tag"))

    if (prefix_or_suffix == "currency") {
      change_previous           <- scales::dollar(change_previous, prefix = base::enc2utf8("\u00A3"))
      change_previous_three_avg <- scales::dollar(change_previous_three_avg, prefix = base::enc2utf8("\u00A3"))
      change_previous_six_avg   <- scales::dollar(change_previous_six_avg, prefix = base::enc2utf8("\u00A3"))
    } else {
      suffix                    <- "%"
      change_previous           <- base::paste0(change_previous, suffix)
      change_previous_three_avg <- base::paste0(change_previous_three_avg, suffix)
      change_previous_six_avg   <- base::paste0(change_previous_six_avg, suffix)
    }

    output$expenses_change <- renderUI({
      bslib::value_box(
        title = tags$span("Compared to preceding month,", tags$br(), expenses_or_assets, "changed by"),
        value = change_previous,
        tagList(
          tags$p("and compared to"),
          tags$span("past 3 months average, by", tags$strong(change_previous_three_avg)),
          tags$span("past 6 months average, by", tags$strong(change_previous_six_avg))
        ),
        showcase = icon,
        theme    = "primary"
      )
    })
  })
}

## To be copied in the UI
# mod_B_01_ui("B_01_1")

## To be copied in the server
# mod_B_01_server("B_01_1")
