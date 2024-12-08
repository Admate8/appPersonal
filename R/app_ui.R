#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # Your application UI logic
    bslib::page_fluid(
      theme = app_theme,
      bslib::page_navbar(
        title = htmltools::tagList(icon("hashtag"), tags$strong("Personal")),
        position = "fixed-top",
        bslib::nav_spacer(),

        # Tabs ----
        ui_A,
        ui_B(golem::get_golem_options("operating_month")),
        ui_C(golem::get_golem_options("operating_month")),
        ui_D(golem::get_golem_options("operating_month")),
        ui_E(golem::get_golem_options("operating_month")),
        ui_F
      ),
      ui_footer
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "appPersonal"
    ),
    rintrojs::introjsUI()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
