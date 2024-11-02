
# Code & Data for the Nutrition Calendar Plot ----------------------------


#' Aggregate Data for the Nutrition Calendar Plot
#'
#' @param date Any valid date.
#' @param type One of "Macros", "Nutrients" or "Others".
#' @param df_nutrition Daily nutrition data. See \code{appPersonal::df_nutrition}.
#'
#' @return Aggregated (daily) data with standardised column names.
#' @noRd
get_nutrition_data <- function(date, type, df_nutrition){
  stopifnot(
    type %in% c("Macros", "Nutrients", "Others"),
    lubridate::is.Date(date)
  )

  date_start_calendar <- lubridate::floor_date(date, unit = "month")
  date_end_calendar   <- lubridate::floor_date(date + months(1), unit = "month") - 1

  df <- df_nutrition |>
    dplyr::filter(dplyr::between(date, date_start_calendar, date_end_calendar)) |>
    dplyr::group_by(date) |>
    dplyr::summarise_if(is.numeric, sum, na.rm = TRUE) |>
    dplyr::ungroup()

  if (type == "Macros") {
    df |>
      dplyr::select(date, col1 = carbs, col2 = prot, col3 = fat) |>
      dplyr::mutate(
        col1 = 4 * col1,
        col2 = 4 * col2,
        col3 = 9 * col3
      )
  }
  else if (type == "Nutrients") df |>  dplyr::select(date, col1 = sat, col2 = fibre, col3 = sugar)
  else df |> dplyr::select(date, col1 = sod, col2 = chol, col3 = potassium)
}


#' Prepare echarts Series for the Nutrition Calendar Plot
#'
#' @inheritParams appPersonal::get_nutrition_data
#' @param target_calories Target calories.
#'
#' @return List of series for be drawn on the echarts plot.
#' @noRd
plot_nutrition_calendar <- function(date, type, df_nutrition, target_calories = 2500) {
  stopifnot(
    type %in% c("Macros", "Nutrients", "Others"), lubridate::is.Date(date),
    is.numeric(target_calories)
  )

  date_start_calendar <- lubridate::floor_date(date, unit = "month")
  date_end_calendar   <- lubridate::floor_date(date + months(1), unit = "month") - 1
  date_for_calendar   <- substr(date_start_calendar, 1, 7)

  # Standardise names to avoid code repetition
  if (type == "Macros") {
    name_1 <- "Carbohydrate"
    name_2 <- "Protein"
    name_3 <- "Fat"
    suffix <- " cal"
  }
  else if (type == "Nutrients") {
    name_1 <- "Saturates"
    name_2 <- "Fibre"
    name_3 <- "Sugar"
    suffix <- "g"
  }
  else {
    name_1 <- "Sodium"
    name_2 <- "Cholesterol"
    name_3 <- "Potassium"
    suffix <- "mg"
  }

  df <- get_nutrition_data(date, type, df_nutrition)
  names(df) <- c("date", name_1, name_2, name_3)
  my_list   <- list(name_1, name_2, name_3)

  df_labels <- tibble::tibble(
    Date = seq.Date(date_start_calendar, date_end_calendar, by = "day"),
    Day  = lubridate::day(Date)
  )
  # Prepare the day of the month labels appearing on the calendar
  df_list_day_of_the_month <- lapply(1:nrow(df_labels), function(i) {list(as.character(df_labels$Date[i]), df_labels$Day[i])})

  # Prepare calories labels
  df_calories <- df_nutrition |>
    dplyr::select(date, cals) |>
    dplyr::group_by(date) |>
    dplyr::summarise(calories = sum(cals, na.rm = TRUE), .groups = "drop")
  df_list_calories <- lapply(1:nrow(df_calories), function(i) {list(as.character(df_calories$date[i]), df_calories$calories[i])})

  # Map the pie charts given dates and labels - it will be a list of echart series
  pieSeries <- purrr::map2(
    .x = df_labels$Date,
    .y = 1:nrow(df_labels),
    .f = function(date, index) {
      list(
        type   = "pie",
        id     = paste0("pie-", index),
        center = date,
        radius = 40,
        color  = list(
          col_palette_nutritions[col_palette_nutritions$category == name_1,]$color,
          col_palette_nutritions[col_palette_nutritions$category == name_2,]$color,
          col_palette_nutritions[col_palette_nutritions$category == name_3,]$color
        ),
        coordinateSystem = "calendar",
        percentPrecision = 0,
        label = list(
          formatter = "{d}%",
          position  = "inside"
        ),
        emphasis = list(
          focus     = "series",
          itemStyle = list(
            shadowBlur    = 10,
            shadowOffsetX = 0,
            shadowColor    = "rgba(0, 0, 0, 0.5)"
          )
        ),
        data = list(
          (df |> dplyr::filter(date == date) |> as.list() |> purrr::imap(~list(name = .y, value = .x)))[[2]],
          (df |> dplyr::filter(date == date) |> as.list() |> purrr::imap(~list(name = .y, value = .x)))[[3]],
          (df |> dplyr::filter(date == date) |> as.list() |> purrr::imap(~list(name = .y, value = .x)))[[4]]
        )
      )
    }
  )

  # Another serie is a scatter plot inscribed in a calendar
  # It will show the day of the month label
  pieSeries[[length(pieSeries) + 1]] <- list(
    id               = "label",
    type             = "scatter",
    coordinateSystem = "calendar",
    symbolSize       = 0,
    emphasis         = list(disabled = TRUE),
    labelLine        = list(show = FALSE),
    silent           = TRUE,
    label            = list(
      show      = TRUE,
      formatter = htmlwidgets::JS(
        "function (params) {
          return echarts.time.format(params.value[0], '{dd}', false);
        }"
      ),
      offset    = list(-100 / 2 + 10, -100 / 2 + 10),
      fontSize  = 14
    ),
    data = df_list_day_of_the_month
  )

  # Another serie is a scatter plot inscribed in a calendar
  # It will label the calories consumption each day
  pieSeries[[length(pieSeries) + 2]] <- list(
    id               = "label_calories",
    type             = "scatter",
    coordinateSystem = "calendar",
    symbolSize       = 0,
    emphasis         = list(disabled = TRUE),
    labelLine        = list(show = FALSE),
    silent           = TRUE,
    label            = list(
      show      = TRUE,
      formatter = htmlwidgets::JS(paste0(
        "
        function(params) {
          var value = params.value[1]
          if (value < ", 0.95 * target_calories, "){ return '{a| ' + parseFloat(value).toLocaleString() + ' kcal' + '}';}
          else if (value >= ", 0.95 * target_calories, "& value <= ", 1.05 * target_calories, "){ return '{b| ' + parseFloat(value).toLocaleString() + ' kcal' + '}';}
          else {return '{c| ' + parseFloat(value).toLocaleString() + ' cal' + '}';}
        ;}
        "
      )),
      rich = list(
        a = list(color = "red", fontSize = 8),
        b = list(color = "green", fontSize = 8),
        c = list(color = "orange", fontSize = 8)
      ),
      offset = list(100 / 2 - 20, 100 / 2 - 5)
    ),
    data = df_list_calories
  )

  # The final list to be fed to e_list with other chart settings
  list(
    tooltip = list(
      trigger        = "item",
      valueFormatter = htmlwidgets::JS(paste0(
        "function(value) {
          return parseFloat(parseFloat(value).toFixed(1)).toLocaleString() + '", suffix, "';
        }"
      ))
    ),
    legend = list(
      data   = my_list,
      bottom = 20
    ),
    calendar = list(
      top        = "middle",
      left       = "center",
      orient     = "vertical",
      cellSize   = list(100, 100),
      monthLabel = list(show = FALSE),
      yearLabel  = list(show = FALSE),
      range      = date_for_calendar,
      dayLabel   = list(
        fontWeight = "bold",
        margin     = 20,
        firstDay   = 1,
        nameMap    = list('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')
      )
    ),
    series = pieSeries
  )
}
