ui_B <- bslib::nav_panel(
  title = tagList(shiny::icon("money-bill-wave"), "Spend"),

  bslib::navset_card_pill(
    title = custom_title("Monthly Spend & Earnings Over Time"),
    bslib::nav_panel("Income Allocation", echarts4r::echarts4rOutput("plot_allocations_over_time", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5)),
    bslib::nav_panel("Spend Breakdown", echarts4r::echarts4rOutput("plot_spend_over_time", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5)),
    bslib::nav_panel("Spend Breakdown (%)", echarts4r::echarts4rOutput("plot_spend_over_time_perc", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5))
  )
)
