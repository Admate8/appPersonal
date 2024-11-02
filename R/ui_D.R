#' Wrapper of the Spend Tab UI
#'
#' @param operating_month golem::get_golem_options("operating_month")
#' @noRd
ui_d <- function(operating_month) {
  bslib::nav_panel(
    title = tagList(shiny::icon("capsules"), "Nutrition"),
    bslib::layout_columns(
      col_widths = c(9, 3),
      bslib::navset_card_pill(
        title = custom_title("Nutrition Over Time"),
        tags$div(
          style = "position: absolute; top: 5px; right: 300px;",
          shinyWidgets::pickerInput(
            inputId  = "select_D_month",
            label    = NULL,
            width    = "200px",
            choices  = format(seq.Date(operating_month - months(2), operating_month, by = "month"), "%B %Y"),
            selected = format(operating_month, "%B %Y")
          )
        ),
        bslib::nav_panel(title = "Macros", echarts4r::echarts4rOutput("plot_cal_macros", width = "100%", height = "650px") |>  shinycssloaders::withSpinner(color = spinners_col, size = 1.5)),
        bslib::nav_panel(title = "Nutrients", echarts4r::echarts4rOutput("plot_cal_nutrients", width = "100%", height = "650px") |>  shinycssloaders::withSpinner(color = spinners_col, size = 1.5)),
        bslib::nav_panel(title = "Others", echarts4r::echarts4rOutput("plot_cal_others", width = "100%", height = "650px") |>  shinycssloaders::withSpinner(color = spinners_col, size = 1.5))
      )

      #uiOutput("target_nutrition_cards", fill = TRUE)
    )
  )
}
