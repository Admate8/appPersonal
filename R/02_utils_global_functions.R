#' Custom Card Title Styling
#'
#' @param title Title (string)
#' @noRd
custom_title <- function(title) {
  tags$span(
    tags$strong(title),
    style = paste0("color: ", primary_col, ";")
  )
}



#' Inverted versions of in
#' @noRd
`%notin%` <- Negate(`%in%`)



#' Round to the Nearest Number
#'
#' @param x Numeric vector.
#' @param accuracy The number to round to.
#'
#' @return Rounded vector of values
round_any <- function(x, accuracy = 0.5){
  stopifnot(is.numeric(x), is.numeric(accuracy))
  round(x / accuracy) * accuracy
}



#' Shade Hex Colour
#'
#' @param hex_color String: hex colour.
#' @param factor Shading factor: negative/positive values will darken/lighten the colour, respectively.
#'
#' @return Shaded hex colour.
get_hex_colour_shade <- function(hex_color, factor = 0.2) {
  if (factor == 0) hex_color
  else {
    rgb_values <- grDevices::col2rgb(hex_color) / 255
    rgb_values <- rgb_values + (1 - rgb_values) * factor
    rgb_values <- base::pmin(base::pmax(rgb_values, 0), 1)
    grDevices::rgb(rgb_values[1], rgb_values[2], rgb_values[3])
  }
}



#' Convert HEX Colour to RGB Colour for the Echart Plots
#'
#' @param hex_color Hex colour.
#' @param opacity Opacity value between 0 and 1.
#'
#' @return Rgba string for the echart plots.
get_rgb_colour <- function(hex_color, opacity = 0.2) {
  stopifnot("'opacity' must be between 0 and 1" = opacity >= 0 & opacity <= 1)
  col_base  <- paste0(grDevices::col2rgb(hex_color), collapse = ", ")
  col_alpha <- opacity
  col_full  <- paste0("rgb(", col_base, ", ", col_alpha, ")")
  return(col_full)
}



#' Add a Tooltip to a Table Header
#'
#' @param value Table header title.
#' @param tooltip Tooltip content.
#' @param ... Not in use.
#'
#' @importFrom tippy tippy
with_tooltip <- function(value, tooltip, ...) {
  tags$div(
    style = "cursor: help",
    tippy::tippy(value, tooltip, ...)
  )
}




# Global Functions for Echarts --------------------------------------------


#' Custom echarts4r::e_datazoom Settings
#'
#' @param ... Any other parameter, see \hfre{slider settings}{https://echarts.apache.org/en/option.html#dataZoom-slider}
#' or \href{data zoom settings}{https://echarts.apache.org/en/option.html#dataZoom}.
#'
#' @return Echart object.
#' @noRd
custom_datazoom <- function(...){
  echarts4r::e_datazoom(
    ...,
    type            = "slider",
    backgroundColor = "white",
    dataBackground  = list(
      lineStyle = list(color = secondary_col, opacity = 0.5),
      areaStyle = list(color = secondary_col, opacity = 0.1)
    ),
    selectedDataBackground = list(
      lineStyle = list(color = secondary_col, opacity = 0.5),
      areaStyle = list(color = secondary_col, opacity = 0.2)
    ),
    fillerColor = get_rgb_colour(secondary_col, 0.05),
    borderColor = get_rgb_colour(secondary_col, 0.8),
    handleStyle = list(
      color       = secondary_col,
      borderColor = get_hex_colour_shade(secondary_col, 0.2),
      borderCap   = "round"
    ),
    moveHandleStyle = list(color = secondary_col, opacity = 0.5),
    labelFormatter  = htmlwidgets::JS(
      "function(value, valueStr) {
          let current_date = new Date(valueStr);
          return current_date.toLocaleDateString('en-GB', {year: 'numeric', month: 'long'});
        }"
    ),
    emphasis = list(
      handleStyle     = list(borderColor = secondary_col),
      moveHandleStyle = list(color = secondary_col, borderColor = secondary_col, opacity = 0.8)
    )
  )
}



#' Custom echarts4r::e_legend Settings
#'
#' @param ... Any other parameter, see \href{legend settings}{https://echarts.apache.org/en/option.html#legend}.
#'
#' @return Echart object.
#' @noRd
custom_legend <- function(...) {
  echarts4r::e_legend(
    ...,
    top               = "middle",
    left              = "left",
    orient            = "vertical",
    itemWidth         = 30,
    itemHeight        = 17,
    backgroundColor   = "rgba(240, 240, 240)",
    borderRadius      = 10,
    textStyle         = list(fontSize = 14),
    selectorLabel     = list(fontWeight = "bold"),
    selectorButtonGap = 20,
    selector          = list(
      list(type = "all", title = "Select All"),
      list(type = "inverse", title = "Inverse")
    )
  )
}
