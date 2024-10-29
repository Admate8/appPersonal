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
        title = tags$strong("#Personal"),

        position = "fixed-top",
        bslib::nav_spacer(),

        # Tab A: Home ----
        bslib::nav_panel(
          title = tagList(shiny::icon("home"), "Home"),
          tableOutput("test_table")
        ),

        # Tab B: Spend ----
        bslib::nav_panel(
          title = tagList(shiny::icon("money-bill-wave"), "Spend")
        )

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
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
