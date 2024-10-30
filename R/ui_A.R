ui_A <- bslib::nav_panel(
  title = tagList(shiny::icon("home"), "Home"),
  bslib::layout_columns(
    col_widths = c(6, 6),
    stringi::stri_rand_lipsum(1),
    tags$img(src = "./www/home_pic.svg", style = "height: 400px; width: 100%;")
  )
)
