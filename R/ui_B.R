#' Wrapper of the Spend Tab UI
#'
#' @param operating_month golem::get_golem_options("operating_month")
#' @noRd
ui_B <- function(operating_month) {
  bslib::nav_panel(
    title = tagList(shiny::icon("money-bill-wave"), "Spend"),

    bslib::navset_card_pill(
      title = custom_title("Monthly Spend & Earnings Over Time"),
      bslib::nav_panel("Income Allocation", echarts4r::echarts4rOutput("plot_allocations_over_time", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5)),
      bslib::nav_panel("Spend Breakdown", echarts4r::echarts4rOutput("plot_spend_over_time", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5)),
      bslib::nav_panel("Spend Breakdown (%)", echarts4r::echarts4rOutput("plot_spend_over_time_perc", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5))
    ),

    bslib::navset_card_pill(
      title = custom_title("Spend Comparison"),
      bslib::nav_panel(
        title = "Figures Change",
        bslib::layout_columns(
          col_widths = c(8, 4),
          reactable::reactableOutput("table_spend_comparison") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
          bslib::layout_columns(
            col_widths  = 12,
            row_heights = c(1, 1),
            mod_B_01_ui("expenses_change"),
            mod_B_01_ui("assets_change")
          )
        )
      ),
      bslib::nav_panel(
        title = "Percentages Change",
        bslib::layout_columns(
          col_widths = c(8, 4),
          reactable::reactableOutput("table_spend_comparison_perc") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
          bslib::layout_columns(
            col_widths  = 12,
            row_heights = c(1, 1),
            mod_B_01_ui("expenses_change_perc"),
            mod_B_01_ui("assets_change_perc")
          )
        )
      )
    ),

    bslib::card(
      bslib::card_title(custom_title("Spend Breakdown & The Biggest and Most Frequent Transactions")),
      tags$div(
        style = "position: absolute; top: 20px; right: 25px;",
        shinyWidgets::pickerInput(
          inputId  = "select_B_month",
          label    = NULL,
          choices  = base::format(base::seq.Date(operating_month - base::months(2), operating_month, by = "month"), "%B %Y"),
          selected = base::format(operating_month, "%B %Y")
        )
      ),
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          title = tags$span(custom_title("Key Performance Indicators"), style = "text-align: center;", class = "sidebar-title"),
          width = 400,
          open = "always",
          bslib::layout_columns(
            col_widths  = 12,
            row_heights = c(1, 1),
            echarts4r::echarts4rOutput("plot_spend_gauge_chart_spend", height = "230px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
            echarts4r::echarts4rOutput("plot_spend_gauge_chart_assets", height = "230px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5)
          )
        ),
        bslib::layout_columns(
          col_widths = c(6, 6),
          plotly::plotlyOutput("plot_spend_breakdown"),
          bslib::layout_columns(
            col_widths  = 12,
            row_heights = c(1, 1),
            reactable::reactableOutput("table_biggest_spend"),
            reactable::reactableOutput("table_most_frequent_spend")
          )
        )
      )
    )
  )
}
