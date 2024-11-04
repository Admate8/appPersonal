
# Code for the Personal Development Relationships Table -------------------


#' UI Solution to the Issue Text
#'
#' @param id_select Personal development table selection ID.
#' @param df_issues Issues data. See \code{appPersonal::df_issues}.
#' @noRd
text_solution_pdev <- function(id_select = NULL, df_issues) {

  if (is.null(id_select)) htmltools::HTML("<center><br><br>Select an issue...</center>")
  else {
    df <- df_issues |>
      dplyr::filter(id == id_select)

    if (is.na(df$solution_method)) htmltools::HTML("<center><br><br>Working on it...</center>")
    else htmltools::HTML(paste0("<center><em>Solution:</em><br><br><span style = 'font-size: 20px;'><b> ", df$solution_method, "</b></span></center>"))
  }
}


#' Plot the Psyche Relationships Table
#'
#' @inheritParams appPersonal::get_df_network_pdev
#' @noRd
table_pdev_relationships <- function(id_select, df_issues, df_issue_relationships) {

  df <- get_df_network_pdev(df_issues, df_issue_relationships)
  df_pdev_scores <- df[["scores"]]
  df_pdev_edges  <- df[["edges"]]

  if (is.null(id_select)) {
    df <- df_pdev_edges |>
      dplyr::left_join(df_pdev_scores, by = dplyr::join_by(to == id))
  } else {
    df <- df_pdev_edges |>
      dplyr::filter(from == id_select) |>
      dplyr::left_join(df_pdev_scores, by = dplyr::join_by(to == id))
  }

  df <- df |>
    dplyr::select(
      component = label,
      score     = value.y,
      reduction = value.x
    ) |>
    unique() |>
    dplyr::arrange(dplyr::desc(reduction))

  df |>
    reactable::reactable(
      compact    = TRUE,
      pagination = FALSE,
      highlight  = TRUE,
      columns    = list(
        component = reactable::colDef(
          headerStyle = list(backgroundColor = table_header_bg_col, color = table_header_col),
          width       = 200,
          name        = "Component"
        ),
        score = reactable::colDef(
          align = "center",
          name  = "Score",
          style = reactablefmtr::color_scales(
            data    = df,
            opacity = 0.4,
            colors  = c("#90EE90", "#FFD580", "#FF7377")
          )
        ),
        reduction = reactable::colDef(
          align       = "center",
          name        = "Reduction",
          headerStyle = list(backgroundColor = table_header_bg_col, color = table_header_col),
          style       = list(background = "#f5f5f5"),
          cell        = reactablefmtr::color_tiles(
            data        = df,
            colors      = c("#8A8E91", "#855A5C", "#66101F"),
            opacity     = 0.6,
            bold_text   = TRUE,
            box_shadow  = TRUE
          )
        )
      )
    )
}
