
# Data & Code for the Exercise Rating Div ---------------------------------


#' Prepare Data for the Target Cards
#'
#' @param df_rating Feels-like rating data. See \code{appPersonal::df_rating}.
#' @noRd
get_df_exercises_felt_like <- function(df_rating) {
  df_rating |>
    dplyr::mutate(date = lubridate::floor_date(date, unit = "month")) |>
    dplyr::group_by(date) |>
    dplyr::summarise(feels_like = mean(rating, na.rm = TRUE), .groups = "drop") |>
    dplyr::mutate(feels_like = round_any(feels_like, 0.5))
}


#' Generate Text for the Exercises Target Value Box
#'
#' @param current_date Any valid date of the form YYYY-MM-DD.
#' @param df_rating Feels-like rating data. See \code{appPersonal::df_rating}.
#' @noRd
get_exercises_gym_target <- function(current_date, df_rating) {

  df <- df_rating |>
    dplyr::mutate(date = lubridate::floor_date(date, unit = "month")) |>
    dplyr::filter(date == current_date)

  gym_attendance_target <- round(0.9 * nrow(df))
  gym_attendance_actual <- df |> stats::na.omit() |> nrow()
  ratio                 <- ifelse(gym_attendance_actual == 0, 0, gym_attendance_actual / gym_attendance_target)

  paste0(gym_attendance_actual, " / ", gym_attendance_target, " (", round(100 * ratio), "%)")
}


#' Generate Star Ratings for the Exercises Felt Like Div
#'
#' @param current_date Any valid date of the form YYYY-MM-DD.
#' @param df_rating Feels-like rating data. See \code{appPersonal::df_rating}.
#' @return shinyRatings HTML object.
#' @noRd
get_exercises_felt_like_stars <- function(current_date, df_rating) {

  df <- get_df_exercises_felt_like(df_rating) |>
    dplyr::filter(date == current_date)

  if (is.na(df$feels_like) || nrow(df) == 0) value <- 0.5
  else value <- df$feels_like

  shinyRatings::shinyRatings("star2", no_of_stars = 10, default = value, disabled = TRUE)
}


#' Generate Star Rating Text for the Exercises Felt Like Div
#'
#' @param current_date Any valid date of the form YYYY-MM-DD.
#' @param df_rating Feels-like rating data. See \code{appPersonal::df_rating}.
#' @noRd
get_exercises_felt_like_text <- function(date_current, df_rating) {

  df <- get_df_exercises_felt_like(df_rating) |>
    dplyr::filter(date == date_current)

  if (is.na(df$feels_like) || nrow(df) == 0) text <- "No data yet!"
  else {
    value <- as.numeric(df$feels_like)
    if (value <= 3) text <- "Don't... just don't."
    else if (value <= 4) text <- "Could have been worse..."
    else if (value <= 5.5) text <- "Just OK."
    else if (value <= 6.5) text <- "Pretty Good!"
    else if (value <= 7.5) text <- "Great! Keep going!"
    else if (value <= 8.5) text <- "Do I actually like it?"
    else text <- "Feels like a GOD!"
  }

  tags$h5(text, style = "display: flex; justify-content: center; align-items: center;")
}
