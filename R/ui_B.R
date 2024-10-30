ui_B <- bslib::nav_panel(
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
  )
)
