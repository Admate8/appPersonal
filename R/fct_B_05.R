
# Data & Code for the Spend Breakdown Sunburst Plot -----------------------


#' Prepare Data for the Spend Sunburst Plot
#'
#' @param selected_month Date of the form "YYYY-MM-DD", e.g. "2023-01-01".
#' @param df_transactions Data with monthly transactions. See \code{appPersonal::df_transactions} as an example.
#'
#' @return A data frame ready to be used by the sunburst plotly plot
#' @noRd
get_df_spend_breakdown <- function(selected_month, df_transactions) {

  # Check if the data contains specified date
  if (selected_month %notin% lubridate::floor_date(df_transactions$date, unit = "month")) {
    base::stop(base::paste("Select date must be between", base::format(base::min(df_transactions$date), "%Y-%m"), "and", base::format(base::max(df_transactions$date), "%Y-%m")))
  }

  # Calculate the spend by category and subcategory
  df_spend <- df_transactions |>
    dplyr::mutate(date_month = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date_month, category, subcategory) |>
    dplyr::summarise(spend = base::sum(value), .groups = "drop") |>
    dplyr::filter(date_month == selected_month)

  ## Establish the structure needed for the sunburst plot
  # 1. Child
  df_child <- df_spend |>
    dplyr::group_by(category, subcategory) |>
    dplyr::summarise(spend = base::sum(spend), .groups = "drop") |>
    dplyr::mutate(
      grandparent = base::paste0("TOTAL_", base::toupper(category), "_", base::toupper(subcategory)),
      parent      = base::paste0("TOTAL_", base::toupper(category)),
      label       = subcategory
    ) |>
    dplyr::select(-subcategory)

  # 2. Parent
  df_parent <- df_spend |>
    dplyr::group_by(category) |>
    dplyr::summarise(spend = base::sum(spend), .groups = "drop") |>
    dplyr::mutate(
      grandparent = base::paste0("TOTAL_", base::toupper(category)),
      parent      = "TOTAL",
      label       = category
    )

  # Grandparent
  df_grandparent <- tibble::tibble(
    spend       = base::sum(df_spend$spend),
    grandparent = "TOTAL",
    parent      = "",
    label       = "Total",
    category    = "Total"
  )

  # Return the combined data frame
  base::rbind(
    df_child,
    df_parent,
    df_grandparent
  ) |>
    dplyr::left_join(col_palette_categories, by = dplyr::join_by(category))
}


#' Plot the Spend Breakdown Sunburst Plot
#'
#' @param df_spend_breakdown Data frame as returned by \code{appPersonal::get_df_spend_breakdown}.
#' @inheritParams appPersonal::get_df_spend_breakdown
#'
#' @return Sunburst plotly chart
#' @noRd
plot_spend_breakdown <- function(df_spend_breakdown, df_transactions) {

  df_spend_breakdown |>
    plotly::plot_ly(
      ids     = ~grandparent,
      labels  = ~label,
      parents = ~parent,
      values  = ~spend,
      hovertemplate = "<extra><b>%{label}</b></extra> \U00A3%{value:,} \n (%{percentParent:.2%})",
      type          = "sunburst",
      branchvalues  = "total",
      marker        = list(colors = ~color),
      sort          = TRUE,
      rotation      = 90,
      insidetextorientation = "radial"
    ) |>
    plotly::layout(margin = list(l = 10, r = 10, t = 0, b = 0)) |>
    plotly::config(displaylogo = FALSE)
}
