
# Code for the Earning Modals ---------------------------------------------


#' Modal UI for the Allowance & Pension Settings
#'
#' @noRd
set_allowances_modal <- function() {
  shiny::modalDialog(
    title = tags$strong("Set Annual Allowances & Pension Settings"),
    tags$div(id = "label-left-container", shinyWidgets::currencyInput(inputId = "set_tax_allowance", label = "Tax", value = 12570, format = "British")),
    tags$div(id = "label-left-container", shinyWidgets::currencyInput(inputId = "set_ni_allowance", label = "National Insurance", value = 12570, format = "British")),
    tags$div(id = "label-left-container", shinyWidgets::currencyInput(inputId = "set_slp2_allowance", label = "Student Loan Plan 2", value = 27288, format = "British")),
    tags$div(id = "label-left-container", shinyWidgets::currencyInput(inputId = "set_slpgrd_allowance", label = "Student Loan Postgrad", value = 21000, format = "British")),
    hr(),
    bslib::layout_columns(
      col_widths = c(6, 6),
      shinyWidgets::materialSwitch(inputId = "is_alpha", label = "Alpha Scheme?", value = TRUE),
      shiny::conditionalPanel(
        condition = "input.is_alpha == false",
        tags$div(id = "label-left-container", shinyWidgets::currencyInput(inputId = "set_pension_contr", label = "Contribution", value = 0.04, format = "percentageUS2dec"))
      )
    ),
    hr(),
    tags$div(id = "label-left-container", shinyWidgets::currencyInput(inputId = "set_scaling_factor", label = "Increase/Decrease the gross annual earnings by ", value = 0, format = "percentageUS2dec")),

    footer = htmltools::tagList(
      bslib::layout_columns(
        col_widths = c(6, 6),
        shinyWidgets::actionBttn(
          inputId = "reset_allowances",
          label   = "Reset",
          style   = "simple",
          color   = "primary",
          size    = "sm"
        ),
        shinyWidgets::actionBttn(
          inputId = "save_allowances",
          label   = "Save & Close",
          style   = "simple",
          color   = "primary",
          size    = "sm"
        )
      )
    )
  )
}


#' UI for the Useful Links Modal
#'
#' @noRd
useful_links_modal <- function() {
  shinyWidgets::sendSweetAlert(
    title      = "Useful Links",
    type       = "info",
    btn_labels = "Close",
    btn_colors = spinners_colour,
    html       = TRUE,
    text       = HTML(
      "<div style = 'text-align: left;'> <ul>
          <li><a href='https://www.gov.uk/income-tax-rates' target='_blank'>Income Tax rates and Personal Allowances</a></li>
          <li><a href='https://www.gov.uk/national-insurance-rates-letters' target='_blank'>National Insurance rates and categories</a></li>
          <li><a href='https://www.civilservicepensionscheme.org.uk/your-pension/managing-your-pension/contribution-rates/' target='_blank'>Civil Service Pension Contribution Rates</a></li>
          <li><a href='https://www.gov.uk/repaying-your-student-loan/what-you-pay' target='_blank'>Student Loan Repayment Information</a></li>
        </ul></div>"
    )
  )
}

