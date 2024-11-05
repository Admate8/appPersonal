#' Wrapper of the Spend Tab UI
#'
#' @param operating_month golem::get_golem_options("operating_month")
#' @noRd
ui_C <- function(operating_month) {
  bslib::nav_panel(
    title = tagList(shiny::icon("sterling-sign"), "Earnings"),
    value = "tab_C",

    bslib::layout_columns(
      col_widths = c(12, 6, 6),
      bslib::navset_card_pill(
        title = custom_title("Accounts"),
        bslib::nav_panel(
          title = "Earnings & Deductions",
          rintrojs::introBox(
            echarts4r::echarts4rOutput("plot_earnings_over_time", height = "500px") |>
              shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
            data.step  = 12,
            data.intro = intro_C_plot_earnings_over_time
          )
        ),
        bslib::nav_panel(
          "Liabilities",
          bslib::layout_sidebar(
            sidebar = bslib::sidebar(
              class    = "height: 100%;",
              position = "right",
              shinyWidgets::radioGroupButtons(
                inputId  = "select_C_loans_view",
                choices  = c("Current loans balance" = "loans_balance", "Loans change over time" = "loan_change", "Interest rates over time" = "loan_interest"),
                direction = "vertical",
                justified = TRUE,
                width     = "100%",
                size      = "lg"
              )
            ),
            rintrojs::introBox(
              echarts4r::echarts4rOutput("plot_liabilities", height = "500px") |>
                shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
              data.step  = 13,
              data.intro = intro_C_plot_liabilities
            )
          )
        )
      ),

      bslib::card(
        bslib::card_title(custom_title("Earnings & Deductions Checks")),
        tags$div(
          style = "position: absolute; top: 15px; right: 20px;",
          shinyWidgets::pickerInput(
            inputId  = "select_C_month",
            label    = NULL,
            choices  = base::format(base::seq.Date(golem::get_golem_options("operating_month") - base::months(5), golem::get_golem_options("operating_month"), by = "month"), "%B %Y"),
            selected = base::format(golem::get_golem_options("operating_month"), "%B %Y")
          )
        ),
        rintrojs::introBox(
          reactable::reactableOutput("table_earnings_check"),
          data.step  = 14,
          data.intro = intro_C_table_earnings_check,
          data.position = "right"
        )
      ),
      bslib::card(
        bslib::layout_columns(
          col_widths = c(4, 6, 2),
          tags$div(
            id = "label-left-container",
            shinyWidgets::currencyInput(
              inputId = "gross_annual_earnings",
              value   = 34963,
              format  = "British",
              label   = NULL
            )
          ),
          tags$div(
            class = "d-flex justify-content-center align-items-center",
            shinyWidgets::radioGroupButtons(
              inputId    = "select_calc_period",
              label      = NULL,
              choices    = c("Yearly" = "year", "Monthly" = "month", "Weekly" = "week"),
              selected   = "year",
              individual = TRUE,
              size       = "sm"
            )
          ),
          shinyWidgets::actionBttn(
            inputId = "alowances_settings",
            label   = NULL,
            icon    = icon("gear"),
            width   = "100%",
            style   = "simple",
            color   = "primary",
            size    = "sm"
          ) |>
            rintrojs::introBox(
              data.step  = 16,
              data.intro = intro_C_alowances_settings,
              data.position = "left"
            )
        ),
        reactable::reactableOutput("table_income_calculator") |>
          rintrojs::introBox(
            data.step  = 15,
            data.intro = intro_C_income_simulation_card,
            data.position = "left"
          )
      ),
      bslib::card(
        bslib::card_title(tags$strong("Gross Earnings with Deductions Breakdown")),
        tags$div(
          style = "position: absolute; top: 25px; right: 35px;",
          shinyWidgets::actionBttn(
            inputId = "deductions_links",
            label   = "Useful Links",
            size    = "sm",
            style   = "simple",
            color   = "primary"
          ) |>
            rintrojs::introBox(
              data.step  = 18,
              data.intro = intro_C_deductions_links,
              data.position = "left"
            )
        ),
        rintrojs::introBox(
          echarts4r::echarts4rOutput("plot_deductions_calculator", height = "500px") |>
            shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
          data.step  = 17,
          data.intro = intro_C_plot_deductions_calculator
        )
      )
    )
  )
}
