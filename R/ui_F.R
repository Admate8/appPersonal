ui_F <- bslib::nav_panel(
  title = tagList(shiny::icon("brain"), "Personal Development"),
  value = "tab_F",

  bslib::navset_card_pill(
    bslib::nav_spacer(),

    bslib::nav_panel(
      title = "Score & Relationships",

      tags$div(
        bslib::layout_columns(
          col_widths = c(7, 5, 7, 5),
          rintrojs::introBox(
            reactable::reactableOutput("table_pdev", height = "500px") |>
              shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
            data.step  = 26,
            data.intro = intro_F_table_pdev,
            data.position = "right"
          ),

          visNetwork::visNetworkOutput("network_pdev") |>
            rintrojs::introBox(
              data.step  = 27,
              data.intro = intro_F_network_pdev,
              data.position = "left"
            ),
          bslib::card(
            uiOutput("text_solution_pdev") |>
              rintrojs::introBox(
                data.step  = 28,
                data.intro = intro_F_text_solution_pdev,
                data.position = "top"
              ),
            height = "145px"
          ),
          rintrojs::introBox(
            reactable::reactableOutput("table_pdev_relationships", height = "145px") |>
              shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
            data.step  = 29,
            data.intro = intro_F_table_pdev_relationships,
            data.position = "top"
          )
        )
      ) |>
        rintrojs::introBox(
          data.step  = 25,
          data.intro = intro_F_page_overview
        )

    ),
    bslib::nav_panel(
      title = "Logs",
      tags$div(
        style = "position: absolute; top: 5px; left: 10px;",
        uiOutput("ui_select_issues")
      ),
      tags$div(
        bslib::layout_columns(
          col_widths = c(-5, 3, 4),
          conditionalPanel(
            condition = "input.gantt_chart_pdev_logs_selected > 0",
            shinyWidgets::downloadBttn(
              outputId = "single_log_download",
              label    = "Download this log as PDF",
              style    = "simple",
              color    = "primary",
              size     = "sm"
            )
          ),
          shinyWidgets::downloadBttn(
            outputId = "multiple_logs_download",
            label    = "Download selected issue logs as PDF",
            style    = "simple",
            color    = "primary",
            size     = "sm"
          )
        ),
        tags$div(
          style = "height: calc(100vh - 65px - 70px - 48px);",
          timevis::timevisOutput("gantt_chart_pdev_logs") |>
            shinycssloaders::withSpinner(color = spinners_col, size = 1.5)
        )
      ) |>
        rintrojs::introBox(
          data.step  = 30,
          data.intro = intro_F_page_overview_2
        )
    )
  )
)
