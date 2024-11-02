
# Data & UI for the Target Nutrition Cards --------------------------------


#' Prepare the Data for the Target Nutrition Cards
#'
#' @param date Any valid date of the form YYYY-MM-DD.
#' @param df_nutrition Daily nutrition data. See \code{appPersonal::df_nutrition}.
#' @noRd
get_df_target_nutrition_cards <- function(date, df_nutrition) {

  date_start_calendar <- lubridate::floor_date(date, unit = "month")
  date_end_calendar   <- lubridate::floor_date(date + months(1), unit = "month") - 1

  df_nutrition |>
    dplyr::filter(dplyr::between(date, date_start_calendar, date_end_calendar)) |>
    dplyr::select(-type) |>
    dplyr::group_by(date) |>
    dplyr::summarise_if(is.numeric, sum, na.rm = TRUE) |>
    dplyr::summarise_if(is.numeric, mean, na.rm = TRUE) |>
    # Compute the relative percentages of the nutrition. "l_" stands for "label_".
    dplyr::mutate(
      l_cal   = paste0(scales::comma(round(cals)), " kcal"),
      l_carbs = paste0(round(100 *  4 * carbs / (4 * carbs + 9 * fat + 4 * prot), 1), "%"),
      l_prot  = paste0(round(100 * 4 * prot / (4 * carbs + 9 * fat + 4 * prot), 1), "%"),
      l_fat   = paste0(round(100 * 9 * fat / (4 * carbs + 9 * fat + 4 * prot), 1), "%"),
      l_sug   = paste0(round(sugar, 1), "g")
    )
}


#' UI with Target Nutrition Cards
#'
#' @inheritParams appPersonal::get_df_target_nutrition_cards
#' @noRd
show_target_nutrition_cards <- function(date, df_nutrition, target_calories = 2400, height = "650px") {
  df_nutrition_cards <- get_df_target_nutrition_cards(date, df_nutrition)

  bslib::layout_columns(
    col_widths  = 12,
    row_heights = c(1, 1, 1, 1, 1),
    height      = height,
    bslib::value_box(
      title    = "Calories",
      value    = df_nutrition_cards$l_cal,
      showcase = icon("pizza-slice"),
      tags$p(paste0("Target: ", scales::comma(target_calories), " cal"))
    ),
    bslib::value_box(
      title    = "Carbohydrate",
      value    = df_nutrition_cards$l_carbs,
      showcase = icon("wheat-awn"),
      tags$p(paste0(round(df_nutrition_cards$carbs, 1), "g")),
      tags$p("Target: 40% - 60%")
    ),
    bslib::value_box(
      title    = "Protein",
      value    = df_nutrition_cards$l_prot,
      showcase = icon("drumstick-bite"),
      tags$p(paste0(round(df_nutrition_cards$prot, 1), "g")),
      tags$p("Target: 25% - 35%")
    ),
    bslib::value_box(
      title    = "Fat",
      value    = df_nutrition_cards$l_fat,
      showcase = icon("bacon"),
      tags$p(paste0(round(df_nutrition_cards$fat, 1), "g")),
      tags$p("Target: 15% - 30%")
    ),
    bslib::value_box(
      title    = "Sugar",
      value    = df_nutrition_cards$l_sug,
      showcase = icon("cookie-bite"),
      tags$p("Target: 50g")
    )
  )
}
