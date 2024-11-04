
# Data & Code for the Psyche Table ----------------------------------------


#' Draw the Psyche Table
#'
#' @param df_issues Issues data. See \code{appPersonal::df_issues}.
#' @noRd
table_pdev <- function(df_issues) {
  df_table_pdev <- df_issues |>
    dplyr::mutate(color = dplyr::case_when(
      domain == "Professional" ~ "#99621E",
      domain == "Personal" ~ "#E4CC37",
      TRUE ~ "#2C5530"
    )) |>
    dplyr::arrange(id)

  df_table_pdev |>
    dplyr::relocate(importance, .before = development_difficulty) |>
    reactable::reactable(
      onClick    = "select",
      selection  = "single",
      compact    = TRUE,
      pagination = FALSE,
      highlight  = TRUE,
      columns    = list(
        .selection = reactable::colDef(
          sticky      = "left",
          style       = list(background = "#f5f5f5"),
          headerStyle = list(backgroundColor = table_header_bg_col)
        ),
        id    = reactable::colDef(show = FALSE),
        issue = reactable::colDef(
          name        = "Issue",
          width       = 200,
          sticky      = "left",
          style       = list(background = "#f5f5f5"),
          headerStyle = list(backgroundColor = table_header_bg_col, color = table_header_col)
        ),
        domain = reactable::colDef(
          cell = reactablefmtr::color_tiles(
            data       = df_table_pdev,
            color_ref  = "color",
            opacity    = 0.6,
            box_shadow = TRUE
          ),
          headerStyle = list(backgroundColor = "#f5f5f5"),
          align       = "center",
          width       = 120,
          header      = with_tooltip("Domain", "<b>Domain</b> specifies what aspect of life the issues relate to.")
        ),
        scope = reactable::colDef(
          headerStyle = list(backgroundColor = "#f5f5f5"),
          header      = with_tooltip("Scope", "<b>Scope</b> specifies which apects of live the issues apply to."),
          width       = 200,
        ),
        primary_obstacle = reactable::colDef(
          headerStyle = list(backgroundColor = "#f5f5f5"),
          header      = with_tooltip("Primary Obstacle", "A single biggest blocker."),
          width       = 170
        ),
        importance = reactable::colDef(
          headerStyle = list(backgroundColor = "#f5f5f5"),
          align       = "center",
          width       = 110,
          header      = with_tooltip("Importance", "(1 - 10)<br>An overall subjective measure of the burden of the issue.")
        ),
        development_difficulty = reactable::colDef(
          headerStyle = list(backgroundColor = "#f5f5f5"),
          align       = "center",
          width       = 120,
          header      = with_tooltip("Development Difficulty", "(1 - 10)<br>An overall subjective measure of improvement difficulty.")
        ),
        score = reactable::colDef(
          defaultSortOrder = "desc",
          align       = "center",
          sticky      = "right",
          headerStyle = list(backgroundColor = table_header_bg_col, color = table_header_col),
          style       = list(background = "#f5f5f5"),
          header      = with_tooltip("Score", "(0 - 100)<br>The <b>Importance</b> score multiplied by the <b>Development Difficulty</b> score."),
          cell        = reactablefmtr::color_tiles(
            data        = df_table_pdev,
            colors      = c("#90EE90", "#FFD580", "#FF7377"),
            opacity     = 0.6,
            bold_text   = TRUE,
            box_shadow  = TRUE
          )
        ),
        color = reactable::colDef(show = FALSE),
        solution_method = reactable::colDef(show = FALSE)
      ),
      defaultColDef = reactable::colDef(
        style = reactablefmtr::color_scales(
          data    = df_table_pdev,
          span    = c(4, 7),
          opacity = 0.4,
          colors  = c("#90EE90", "#FFD580", "#FF7377")
        )
      ),
      theme = reactable::reactableTheme(rowSelectedStyle = list(backgroundColor = "#eee", boxShadow = "inset 2px 0 0 0 #ffa62d"))
    )
}
