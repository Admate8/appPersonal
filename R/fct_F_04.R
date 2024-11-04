
# Data, Settings and UI for the Logs tab ----------------------------------


#' Prepare Unique Domain-Issue Categories for the pickerInput
#'
#' @param df_issue_logs Issue relationships data. See \code{appPersonal::df_issue_relationships}.
#' @param df_issues Issues data. See \code{appPersonal::df_issues}.
#' @noRd
get_df_pdev_progress_split <- function(df_issue_logs, df_issues) {
  df_issue_logs |>
    dplyr::left_join(
      df_issues |> dplyr::select(id_issue = id, issue, domain, score),
      by = "issue"
    ) |>
    dplyr::mutate(id = dplyr::row_number()) |>
    dplyr::mutate(name = paste0("(ID: ", id_issue, ") ", issue)) |>
    dplyr::arrange(id_issue) |>
    dplyr::select(name, domain) |>
    unique()
}


#' Prepare Data for the Personal Development Gantt Chart
#'
#' @param df_issue_logs Issue relationships data. See \code{appPersonal::df_issue_relationships}.
#' @param df_issues Issues data. See \code{appPersonal::df_issues}.
#' @noRd
get_df_pdev_gantt <- function(df_issue_logs, df_issues) {

  # Formatted data for the personal development gantt chart
  df_pdev_progress_ready <- df_issue_logs |>
    dplyr::left_join(
      df_issues |> dplyr::select(id_issue = id, issue, domain, score),
      by = "issue"
    ) |>
    dplyr::mutate(id = dplyr::row_number())

  # Formatted groups for the personal development gantt chart
  df_pdev_progress_groups <- df_pdev_progress_ready |>
    dplyr::select(id = issue, id_issue) |>
    unique() |>
    dplyr::mutate(content = paste0("<b>", id, "</b>"))

  return(list(
    "df_progress"        = df_pdev_progress_ready,
    "df_progress_groups" = df_pdev_progress_groups
  ))
}



#' Plot the Logs Psyche Gantt Chart
#'
#' @param selected_issue_ids A list of selected issues of the form: `(ID: n) ISSUE NAME`, where `n` is an issue id.
#' @inheritParams appPersonal::get_df_pdev_gantt
#' @noRd
plot_gantt_chart_pdev_logs <- function(selected_issue_ids, df_issue_logs, df_issues) {

  # Formatted data for the personal development gantt chart
  df <- df_issue_logs |>
    dplyr::left_join(
      df_issues |> dplyr::select(id_issue = id, issue, domain, score),
      by = "issue"
    ) |>
    dplyr::mutate(id = dplyr::row_number())

  # Formatted groups for the personal development gantt chart
  df_groups <- df |>
    dplyr::select(id = issue, id_issue) |>
    unique() |>
    dplyr::mutate(content = paste0("<b>", id, "</b>"))

  if (!is.null(selected_issue_ids)) {
    df        <- df |>
      dplyr::filter(id_issue %in% as.numeric(gsub("[^0-9]", "", selected_issue_ids)))
    df_groups <- df_groups |>
      dplyr::filter(id_issue %in% as.numeric(gsub("[^0-9]", "", selected_issue_ids)))
  }

  timevis::timevis(
    data   = df |> dplyr::rename(start = date, group = issue, description = log),
    groups = df_groups
  )
}
