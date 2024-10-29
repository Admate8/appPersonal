ui_footer <- tags$footer(
  style = glue::glue(
    "background-color: {get_hex_colour_shade(secondary_col, 0.5)};
    position: fixed;
    margin-left: -15px;
    bottom: 0px;
    left = 0px;
    width: calc(100% + 24px);
    height: 65px;
    border-top: 2px solid {get_hex_colour_shade(secondary_col, 0.2)};
    padding: 15px 40px 15px 30px;"
  ),

  tags$div(
    style = glue::glue("display: flex; justify-content: space-between; color: {primary_col};"),
    tags$div(
      class = "left-text",
      HTML(paste("&copy", lubridate::year(Sys.Date()), "Adrian Wisnios"))
    ),
    tags$div(
      class = "right-text",
      htmltools::tagList(
        tags$a(
          href = "mailto:adrian9.wisnios@gmail.com",
          icon("square-envelope", style = glue::glue("color: {primary_col}; font-size: 2rem;")),
          target = "_blank"
        ),

        tags$a(
          href = "https://www.linkedin.com/in/adrian-wisnios-022408215/",
          icon("linkedin", style = glue::glue("color: {primary_col}; font-size: 2rem;")),
          target = "_blank"
        ),

        tags$a(
          href = "https://github.com/Admate8",
          icon("square-github", style = glue::glue("color: {primary_col}; font-size: 2rem;")),
          target = "_blank"
        ),

        tags$a(
          href = "https://www.instagram.com/admate8/",
          icon("square-instagram", style = glue::glue("color: {primary_col}; font-size: 2rem;")),
          target = "_blank"
        )
      )
    )
  )
)
