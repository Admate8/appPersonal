#' Run the Shiny Application
#'
#' @param operating_month Gloabl app setting that controls things like plot sliders
#' defaults or earnings calculations. In the live version of the app, I have it
#' set to the latest full calendar. In the static version, it makes sense to set
#'  it to the max available.
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart           = NULL,
  options           = list(),
  enableBookmarking = NULL,
  uiPattern         = "/",

  operating_month   = lubridate::floor_date(max(appPersonal::df_earnings$date), unit = "month"),
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui                = app_ui,
      server            = app_server,
      onStart           = onStart,
      options           = options,
      enableBookmarking = enableBookmarking,
      uiPattern         = uiPattern
    ),
    golem_opts = list(
      operating_month = operating_month
    )
  )
}
