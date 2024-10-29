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
