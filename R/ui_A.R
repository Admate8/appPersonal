ui_A <- bslib::nav_panel(
  title = tagList(shiny::icon("home"), "Home"),
  bslib::layout_columns(
    col_widths = c(6, 6),
    tags$div(
      style = "
        display: grid;
        height: calc(100vh - 65px - 70px - 48px);
        grid-template-rows: 1fr 2fr;",
      tags$div(
        style = "display: flex; align-items: center;",
        tags$span(
          tags$h1(tags$strong("Welcome to the #Personal demo dashboard!")),
          style = paste0("color: ", primary_col, "; text-align: center;")
        )
      ),
      tags$div(tags$img(src = "./www/home_pic.svg", style = "height: 400px; width: 100%;"))
    ),

    tags$div(
      tags$span(
        tags$h5(tags$strong("The backstory")),
        style = paste0("color: ", primary_col, ";")
      ),
      tags$div(
        style = "text-align: justify;",
        HTML(
          "When introducing customers to the magic of Shiny dashboards,
            I sometimes wish I had a go-to app to really show off its potential.
            I can rave about past projects, but without being able to share them
            directly (thanks to NDAs and sensitive data), it can feel like the
            message doesn't quite hit home. Well, this demo <em>is</em> that punchy showcase!
            (Or, for those familiar with Shiny, consider it a friendly glimpse of
            its exciting possibilities!)"
        )
      ),
      br(), br(),
      tags$span(
        tags$h5(tags$strong("What is #Personal")),
        style = paste0("color: ", primary_col, ";")
      ),
      tags$div(
        style = "text-align: justify;",
        HTML(
          "I spent a long time wondering what this app should showcase,
            only to realise the perfect idea was right under my nose - an app I
            already use to manage... well, <em>me</em>! This demo is inspired by
            my personal dashboard (hence the name!) and features artificial
            data (because no one needs to know my monthly supermarket splurges).
            It's a fun and practical example of how valuable it can be to keep
            track of different parts of life - from monthly finances to workouts
            and personal growth."
        )
      ),
      br(), br(),
      tags$span(
        tags$h5(tags$strong("Can I upload my own data?")),
        style = paste0("color: ", primary_col, ";")
      ),
      tags$div(
        style = "text-align: justify;",
        HTML(
          "Well, it's just a demo... <em>for now</em>! But if that's something
            you'd be interested in, just reach out and let me know!"
        )
      ),
      br(), br(),

      bslib::layout_columns(
        col_widths = c(7, 5),
        tags$div(
          tags$span(
            tags$h5(tags$strong("Not sure where to start?")),
            style = paste0("color: ", primary_col, ";")
          ),
          tags$div(
            style = "text-align: justify;",
            HTML(
              "I'm here to guide you every step of the way!"
            )
          )
        ),

        tags$div(
          style = "margin-top: 10px;",
          shinyWidgets::actionBttn(
            inputId = "init_guidance",
            label   = "Show me!",
            icon    = icon("shoe-prints"),
            style   = "simple",
            color   = "primary",
            size    = "md"
          )
        )
      )
    )
  )
)
