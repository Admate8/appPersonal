
# Code for the Exercises Rating Calendar ----------------------------------


#' Plot Exercises Rating Calendar
#'
#' @param year Numeric year, e.g. 2024.
#' @param df_rating Feels-like rating data. See \code{appPersonal::df_rating}.
#' @noRd
plot_exercises_rating_calendar <- function(year, df_rating) {
  df <- df_rating |>
    # This makes more sense when the data is dynamic
    dplyr::mutate(rating = dplyr::case_when(
      date < Sys.Date() & is.na(rating) ~ -1L,
      date >= Sys.Date() & is.na(rating) ~ -2L,
      TRUE ~ rating
    )) |>
    tidyr::pivot_wider(names_from = "type", values_from = "rating") |>
    dplyr::mutate(label = lubridate::day(date)) |>
    dplyr::filter(lubridate::year(date) == year)

  df |>
    echarts4r::e_chart(date) |>
    echarts4r::e_calendar(
      range     = unique(lubridate::year(df$date)),
      yearLabel = list(show = FALSE),
      top       = "center",
      itemStyle = list(borderWidth = 0.5),
      width     = "92%"
    ) |>
    echarts4r::e_heatmap(
      Exercises,
      coord_system = "calendar",
      emphasis     = list(itemStyle = list(color = "#E3B23C")),
      name         = "Exercises"
    ) |>
    echarts4r::e_heatmap(
      Hobby,
      coord_system = "calendar",
      emphasis     = list(itemStyle = list(color = "#E3B23C")),
      name         = "Hobby"
    ) |>
    echarts4r::e_visual_map(
      max     = 10,
      serie   = Exercises,
      top     = "center",
      inRange = list(color = c("#EEE5E9", "#023C40"))
    ) |>
    echarts4r::e_tooltip(formatter = htmlwidgets::JS(
      "function(params) {
      let
        date_trace   = new Date(params.value[0]).toLocaleDateString('en-GB', {month: 'long', day: 'numeric', year: 'numeric'}),
        value_trace  = params.value[1],
        name_trace   = params.seriesName,
        marker_trace = params.marker;

      if (parseFloat(value_trace) === -1) {value = '<b>Day Skipped</b>';}
      else if (parseFloat(value_trace) === -2) {value = '<b>No Data Yet</b>';}
      else {value = '<b>Score: ' + parseFloat(value_trace) + '</b>';}

      return '<div style = \"text-align: center;\"><b>' + date_trace + '</b></div>' +
        name_trace + '<br>' +
        '<div style = \"float:left\">' + marker_trace + '</div>' +
        '<div style = \"float:right\">' + value + '</div>'
    }"
    ))
}
