
# Data, Settings and UI for the Logs tab ----------------------------------


#' Prepare Unique Domain-Issue Categories for the pickerInput
#'
#' @param df_issue_logs Issue relationships data. See \code{appPersonal::df_issue_relationships}.
#' @param df_issues Issues data. See \code{appPersonal::df_issues}.
#' @noRd
get_df_pdev_progress_split <- function(df_issue_logs, df_issues) {
  df <- df_issue_logs |>
    dplyr::left_join(
      df_issues |> dplyr::select(id_issue = id, issue, domain, score),
      by = "issue"
    ) |>
    dplyr::mutate(id = dplyr::row_number()) |>
    dplyr::arrange(id_issue) |>
    dplyr::select(id_issue, domain, issue) |>
    unique()

  split(setNames(df$id_issue, df$issue), df$domain)
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

  df        <- get_df_pdev_gantt(df_issue_logs, df_issues)[["df_progress"]]
  df_groups <- get_df_pdev_gantt(df_issue_logs, df_issues)[["df_progress_groups"]]

  if (!is.null(selected_issue_ids)) {
    df        <- df |>
      dplyr::filter(id_issue %in% selected_issue_ids)
    df_groups <- df_groups |>
      dplyr::filter(id_issue %in% selected_issue_ids)
  }

  timevis::timevis(
    data   = df |> dplyr::rename(start = date, group = issue, description = log),
    groups = df_groups
  )
}


#' Function Displaying Selected Log (from the gantt chart)
#'
#' @param selected_log Id of the selected log
#'
#' @return Modal containing details about the selected log
#' @noRd
modal_selected_log <- function(selected_log, df_issue_logs, df_issues) {

  df <- get_df_pdev_gantt(df_issue_logs, df_issues)[["df_progress"]] |>
    dplyr::filter(id == selected_log)

  shiny::modalDialog(
    title     = htmltools::HTML(paste0(df$domain, "<b>: ", df$content, "</b><br><em>", format(df$date, "%d %B %Y"), "</em>")),
    htmltools::HTML(paste0(df$log, collapse = "")),
    size      = "xl",
    easyClose = TRUE,
    footer    = NULL
  )
}
