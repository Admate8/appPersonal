
# Data & Code for the Exercises Over Time Plot ----------------------------


#' Plot Exercises Types Over Time
#'
#' This function will throw a few warnings due to the way
#' NAs are treated when plotting e_scatter serie
#'
#' @param year Numeric, e.g. 2024.
#' @param df_exercises Exercises data. See \code{appPersonal::df_exercises}.
#' @noRd
plot_exercises_over_time <- function(year, df_exercises) {

  df_exercises_unique <- df_exercises |>
    dplyr::select(exercise, type, category) |>
    unique() |>
    dplyr::arrange(exercise)

  slide_start <- if (min(df_exercises$date) <= as.Date(paste0(year, "-01-01"))) as.Date(paste0(year, "-01-01")) else min(df_exercises$date)
  slide_end   <- if (max(df_exercises$date) <= as.Date(paste0(year, "-12-31"))) max(df_exercises$date) else as.Date(paste0(year, "-12-31"))

  df_exercises |>
    dplyr::group_by(exercise) |>
    echarts4r::e_chart(x = date, timeline = TRUE) |>
    echarts4r::e_line(
      serie      = weight,
      symbol     = "diamond", #"image://https://static.thenounproject.com/png/499185-200.png",
      name       = "Weight",
      symbolSize = 13,
      color      = primary_col,
      lineStyle  = list(color = primary_col),
      tooltip    = list(valueFormatter = htmlwidgets::JS(
        "function(value) {
          return parseFloat(value) + 'kg';
        }"
      )),
      legend     = FALSE,
      areaStyle  = list(color = htmlwidgets::JS(
        "new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          {
            offset: 0,
            color: 'rgb(2, 60, 64)'
          },
          {
            offset: 1,
            color: 'rgb(255, 255, 255)'
          }
        ])"
      ))
    ) |>
    echarts4r::e_x_axis(
      axisPointer = list(label = list(formatter = htmlwidgets::JS(
        "function(params) {
          let current_date = new Date(params.value);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long', day: 'numeric'});
        }"
      )))
    ) |>
    echarts4r::e_y_axis(formatter = "{value}kg", scale = TRUE) |>
    echarts4r::e_tooltip(trigger = "axis") |>
    echarts4r::e_grid(top = "25%") |>
    custom_datazoom( startValue = slide_start, endValue = slide_end) |>
    echarts4r::e_timeline_opts(
      left    = "12%",
      top     = "-15%",
      symbol  = "diamond",
      width   = "40%",
      padding = 50,
      lineStyle       = list(color = primary_col, type = "dotted", width = 0.5),
      label           = list(show = FALSE, color = primary_col, overflow = "truncate"),
      itemStyle       = list(color = primary_col, opacity = 0.7),
      checkpointStyle = list(symbol = "pin", symbolSize = 20, color = secondary_col),
      controlStyle    = list(color = primary_col, borderColor = primary_col),
      progress        = list(
        lineStyle = list(color = secondary_col, type = "dotted", width = 0.5),
        itemStyle = list(color = secondary_col, opacity = 0.7)
      ),
      emphasis        = list(
        itemStyle    = list(color = secondary_col, opacity = 0.7),
        controlStyle = list(color = secondary_col, borderColor = secondary_col)
      )
    ) |>
    echarts4r::e_timeline_serie(
      title = lapply(1:nrow(df_exercises_unique), function(i) {
        list(
          text    = df_exercises_unique$exercise[i],
          subtext = paste0(
            "Type: ", df_exercises_unique$type[i],
            ", Category: ", df_exercises_unique$category[i]
          )
        )
      })
    )
}
