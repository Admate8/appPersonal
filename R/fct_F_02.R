
# Data & Code for the Personal Development Relationships Network C --------


#' Prepare Data for the Network Chart
#'
#' @param df_issues Issues data. See \code{appPersonal::df_issues}.
#' @param df_issue_relationships Issue relationships data. See \code{appPersonal::df_issue_relationships}.
#' @noRd
get_df_network_pdev <- function(df_issues, df_issue_relationships) {

  # Data with nodes details
  df_pdev_scores <- df_issues |>
    dplyr::select(id, label = issue, group = domain, value = score) |>
    dplyr::mutate(
      shadow = rep(TRUE, dplyr::n()),
      title  = paste0("<center><b>", label, "</b><br>(score: ", value, ")</center>"),
      color  = dplyr::case_when(
        group == "Professional" ~ "#99621E",
        group == "Personal" ~ "#E4CC37",
        TRUE ~ "#2C5530"
      )
    )

  # Randomise the order
  df_pdev_scores <- df_pdev_scores[sample(nrow(df_pdev_scores)),]

  # Data storing details shown on hover on the connections between nodes
  df_pdev_edges <- df_issue_relationships |>
    dplyr::rename(value_strength = value) |>
    dplyr::group_by(from) |>
    dplyr::reframe(to, from_name, to_name, value_strength, value = value_strength / sum(value_strength)) |>
    dplyr::left_join(df_pdev_scores |> dplyr::select(id, score = value), by = dplyr::join_by(from == id)) |>
    dplyr::mutate(
      value = round(value * score),
      title = paste0("<center>Improving <b>", from_name, "</b><br>by <b>", value, "</b> points will improve<br><b>", to_name, "</b><br>by the same amount.</center>")
    ) |>
    dplyr::select(to = from, from = to, value, title)

  return(list(
    "scores" = df_pdev_scores,
    "edges"  = df_pdev_edges
  ))
}


#' Plot the Psyche Network Chart
#'
#' @inheritParams appPersonal::get_df_network_pdev
#' @noRd
plot_network_pdev <- function(selected_node = NULL, df_issues, df_issue_relationships){

  df <- get_df_network_pdev(df_issues, df_issue_relationships)
  df_pdev_scores <- df[["scores"]]
  df_pdev_edges  <- df[["edges"]]

  if (is.null(selected_node)) {
    visNetwork::visNetwork(
      nodes = df_pdev_scores,
      edges = df_pdev_edges
    ) |>
      visNetwork::visEdges(arrows = "from") |>
      visNetwork::visOptions(
        nodesIdSelection = list(enabled = TRUE, main = "Select by Issue", style = "width: 200px"),
        highlightNearest = list(enabled = TRUE, degree = 0, labelOnly = TRUE, hideColor = "rgba(200,200,200,0.1)")
      ) |>
      visNetwork::visIgraphLayout(layout = "layout_in_circle") |>
      visNetwork::visInteraction(zoomView = FALSE) |>
      visNetwork::visEdges(
        smooth         = list(enabled = TRUE, type = "curvedCW", roundness = 0.2),
        selectionWidth = 2,
        color          = list(opacity = 0.2)
      )
  } else {
    visNetwork::visNetwork(
      nodes = df_pdev_scores,
      edges = df_pdev_edges
    ) |>
      visNetwork::visEdges(arrows = "from") |>
      visNetwork::visOptions(
        nodesIdSelection = list(enabled = TRUE, selected = selected_node, style = "width: 200px", main = "Select by Issue"),
        highlightNearest = list(enabled = TRUE, degree = 0, labelOnly = TRUE, hideColor = "rgba(200,200,200,0.1)")
      ) |>
      visNetwork::visIgraphLayout(layout = "layout_in_circle") |>
      visNetwork::visInteraction(zoomView = FALSE) |>
      visNetwork::visEdges(
        smooth         = list(enabled = TRUE, type = "curvedCW", roundness = 0.2),
        selectionWidth = 2,
        color          = list(opacity = 0.2)
      )
  }
}
