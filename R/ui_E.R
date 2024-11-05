ui_E <- function(operating_month) {
  bslib::nav_panel(
    title = tagList(shiny::icon("dumbbell"), "Exercises"),
    value = "tab_E",

    bslib::layout_columns(
      col_widths = c(12, 12, 12),
      bslib::card(
        bslib::card_title(custom_title("Measurements Over Time")),
        reactable::reactableOutput("table_measurements") |>
          rintrojs::introBox(
            data.step  = 20,
            data.intro = intro_E_table_measurements
          )
      ),
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          class = "d-flex align-items-center justify-content-center",
          title = tags$span(custom_title("Exercises KPIs"), style = "text-align: center;", class = "sidebar-title"),
          open  = "always",
          shinyWidgets::radioGroupButtons(
            inputId   = "select_E_month",
            choices   = format(seq.Date(operating_month - months(2), operating_month, by = "month"), "%B %Y"),
            selected  = format(operating_month, "%B %Y"),
            direction = "vertical",
            width     = "200px",
            size      = "sm"
          )
        ),
        bslib::layout_columns(
          col_widths = c(4, 4, 4),
          bslib::value_box(
            title    = "Exercises Hit Target",
            value    = textOutput("exercises_gym_target"),
            showcase = icon("bullseye")
          ),
          bslib::value_box(
            title    = "Target BMI",
            value    = "18.5 - 24.9",
            showcase = icon("weight-scale"),
            tags$p("Waist-to-Hip Ratio: < 0.9")
          ),
          htmltools::tagList(
            tags$h4(tags$strong("How did it feel?"), style = "display: flex; justify-content: center; align-items: center;"),
            tags$div(
              style = "width: 100%; display: flex; justify-content: center; align-items: center;",
              uiOutput("exercises_felt_like_stars")
            ),
            uiOutput("exercises_felt_like_text")
          )
        )
      ) |>
        rintrojs::introBox(
          data.step  = 21,
          data.intro = intro_E_exercises_gym_targets
        ),
      bslib::card(
        tags$div(
          style = "position: absolute; top: 20px; right: 25px;",
          shinyWidgets::pickerInput(
            inputId  = "select_E_year",
            label    = NULL,
            choices  = paste("Year", seq(2023, lubridate::year(Sys.Date()))),
            selected = paste("Year", lubridate::year(operating_month))
          )
        ),
        bslib::card_title(custom_title("Rating and Exercises Over Time")),
        class = "center",
        rintrojs::introBox(
          echarts4r::echarts4rOutput("exercises_rating_calendar", height = "200px", width = "100%") |>
            shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
          data.step  = 22,
          data.intro = intro_E_exercises_rating_calendar
        ),
        rintrojs::introBox(
          echarts4r::echarts4rOutput("exercises_over_time", height = "300px", width = "100%") |>
            shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
          data.step  = 23,
          data.intro = intro_E_exercises_over_time
        )
      ),
      bslib::card(
        bslib::card_title(custom_title("Exercises During Gym Sessions")),
        rintrojs::introBox(
          echarts4r::echarts4rOutput("gym_sessions_over_time", height = "300px", width = "100%") |>
            shinycssloaders::withSpinner(color = spinners_col, size = 1.5),
          data.step  = 24,
          data.intro = intro_E_gym_sessions_over_time
        )
      )
    )
  )
}
