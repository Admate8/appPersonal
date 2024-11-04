ui_F <- bslib::nav_panel(
  title = tagList(shiny::icon("brain"), "Personal Development"),

  bslib::navset_card_pill(
    bslib::nav_panel(
      title = "Score & Relationships",

      bslib::layout_columns(
        #col_widths = c(7, 5, 7, 5),
        reactable::reactableOutput("table_pdev", height = "500px") |> shinycssloaders::withSpinner(color = spinners_col, size = 1.5)
        # visNetwork::visNetworkOutput("network_psyche"),
        # bslib::card(uiOutput("text_solution_psyche"), height = "145px"),
        # reactable::reactableOutput("table_psyche_relationships", height = "145px") |> shinycssloaders::withSpinner(color = spinners_colour, size = 1.5)
      )
    )
    # bslib::nav_panel(
    #   title = "Progress Logs",
    #   bslib::layout_columns(
    #     col_widths = c(12, 12),
    #     bslib::navset_card_pill(
    #       bslib::nav_spacer(),
    #       bslib::nav_panel(
    #         title = "Logs",
    #         ui_select_A_issue(),
    #         ui_download_logs(),
    #         bslib::layout_columns(
    #           col_widths = c(12, 12),
    #           timevis::timevisOutput("gantt_chart_psyche_logs") |> shinycssloaders::withSpinner(color = spinners_colour, size = 1.5)
    #         )
    #       ),
    #       bslib::nav_panel(
    #         title = "Score over Time",
    #         ui_select_B_issue(),
    #         reactable::reactableOutput("table_psyche_score_over_time")
    #       )
    #     )
    #   )
    # )
  )
)
