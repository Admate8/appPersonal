
# Data & Code for the Measurements Over Time Table ------------------------


#' Prepare Data for the Measurements Table
#'
#' @param df_measurements Weekly measurements data. See \code{appPersonal::df_measurements}.
#' @noRd
get_df_measurements_table <- function(df_measurements) {
  df_measurements |>
    dplyr::mutate(date = format(date, "%d %b %Y")) |>
    tidyr::pivot_longer(-date) |>
    tidyr::pivot_wider(names_from = date) |>
    dplyr::left_join(
      df_measurements |>
        tidyr::pivot_longer(-date) |>
        dplyr::group_by(name) |>
        dplyr::summarise(series = list(value)),
      by = "name"
    ) |>
    dplyr::mutate(
      name = stringr::str_to_title(gsub("_", " ", name)),
      name = ifelse(name %in% c("Bmi", "Bmr"), toupper(name), name)
    )
}



#' Draw the Static Measurements Table
#'
#' @inheritParams appPersonal::get_df_measurements_table
#' @noRd
table_measurements <- function(df_measurements) {
  df <- get_df_measurements_table(df_measurements)

  df |>
    reactable::reactable(
      compact    = TRUE,
      sortable   = FALSE,
      pagination = FALSE,
      highlight  = TRUE,
      columns    = list(
        name = reactable::colDef(
          name        = "Measurement",
          width       = 200,
          sticky      = "left",
          headerStyle = list(backgroundColor = table_header_bg_col, color = table_header_col),
          style       = list(backgroundColor = "#f7f7f7", fontWeight = "bold")
        ),
        series = reactable::colDef(
          name        = "Series",
          sticky      = "right",
          width       = 300,
          style       = list(borderLeft = "1px solid #eee"),
          align       = "center",
          headerStyle = list(backgroundColor = table_header_bg_col, color = table_header_col),
          # The sparkline introduces 12 warnings, but it works as the result is
          # translated to htmltools::tag() from shiny.tag.list
          cell        = reactablefmtr::react_sparkline(
            df,
            show_area        = TRUE,
            highlight_points = reactablefmtr::highlight_points(first = "#325d88", last = "#325d88", all = "gray"),
            labels           = c("first", "last"),
            label_size       = "0.6em",
            tooltip_size     = "0.8em"
          )
        )
      ),
      rowStyle      = function(index) if (index %in% c(7, 8, 12)) list(`border-bottom` = "thin solid"),
      defaultColDef = reactable::colDef(maxWidth = 80),
      theme         = reactable::reactableTheme(
        highlightColor = "#f7f7f7",
        style          = list(borderRadius = 10)
      )
    )
}
