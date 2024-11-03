
# Data & Code for the Gym Sessions Over Time ------------------------------



#' Plot Gym Sessions Chart
#'
#' @param df_exercises Exercises data. See \code{appPersonal::df_exercises}.
#' @noRd
plot_gym_sessions <- function(df_exercises) {
  df_exercises |>
    dplyr::select(date, exercise) |>
    dplyr::filter(dplyr::between(
      date,
      max(df_exercises$date) - base::months(5),
      max(df_exercises$date)
    )) |>
    dplyr::mutate(
      date  = format(date, "%d %b"),
      value = 1
    ) |>
    tidyr::pivot_wider(
      names_from  = "date",
      values_from = "value",
      values_fill = 0
    ) |>
    tidyr::pivot_longer(
      cols      = -"exercise",
      names_to  = "date",
      values_to = "value"
    ) |>
    dplyr::mutate(xercise = forcats::fct_relevel(exercise)) |>
    dplyr::arrange(dplyr::desc(exercise)) |>
    echarts4r::e_chart(x = date) |>
    echarts4r::e_heatmap(
      y = exercise,
      z = value,
      emphasis = list(itemStyle = list(color = "#E3B23C")),
      itemStyle = list(borderWidth = 2, borderColor = "white")
    ) |>
    echarts4r::e_x_axis(
      axisLabel = list(
        interval = 0,
        rotate   = 30
      )
    ) |>
    echarts4r::e_visual_map(
      serie   = value,
      type    = "piecewise",
      top     = "center",
      inRange = list(color = c("#EEE5E9", "#023C40")),
      show    = FALSE
    ) |>
    echarts4r::e_grid(left = "15%", top = "-10%")
}
