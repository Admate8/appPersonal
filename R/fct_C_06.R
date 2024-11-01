
# Data & Code for the Custom Income Calculator Table & Plot ---------------

#' Deduction 1: Pension
#'
#' @param annual_pensionable_earnings Vector of the annual pensionable earnings.
#' @param alpha Is it the Alpha scheme? TRUE/FALSE.
#' @param contribution If alpha == FALSE, provide the pension contribution.
#'
#' @return Vector of the Pension deductions.
#' @noRd
get_pension_deduction <- function(annual_pensionable_earnings, alpha = TRUE, contribution = NULL) {
  stopifnot(is.numeric(annual_pensionable_earnings), annual_pensionable_earnings > 0)
  if (alpha == TRUE) {
    base::ifelse(annual_pensionable_earnings <= 32000, 0.046 * annual_pensionable_earnings,
                 base::ifelse(annual_pensionable_earnings <= 56000, 0.0545 * annual_pensionable_earnings,
                              base::ifelse(annual_pensionable_earnings <= 150000, 0.0735 * annual_pensionable_earnings,
                                           0.0805 * annual_pensionable_earnings)))
  } else {
    stopifnot(dplyr::between(contribution, 0, 100), is.numeric(contribution))
    annual_pensionable_earnings * contribution
  }
}


#' Deduction 2: Tax
#'
#' @param annual_taxable_earnings Vector of the annual taxable earnings.
#' @param tax_allowance Tax allowance.
#'
#' @return Vector of the Tax deductions.
#' @noRd
get_tax_deduction <- function(annual_taxable_earnings, tax_allowance = 12570){
  stopifnot(is.numeric(annual_taxable_earnings), annual_taxable_earnings > 0, is.numeric(tax_allowance), tax_allowance > 0)

  base::ifelse(annual_taxable_earnings <= tax_allowance, 0,
               base::ifelse(annual_taxable_earnings <= 50270, (annual_taxable_earnings - tax_allowance) * 0.2,
                            base::ifelse(annual_taxable_earnings <= 125140, (50270 - tax_allowance) * 0.2 + (annual_taxable_earnings - 50270) * 0.4,
                                         (50270 - tax_allowance) * 0.2 + (125140 - 50270) * 0.4 + (annual_taxable_earnings - 125140) * 0.45)))
}


#' Deduction 3: National Insurance
#'
#' @param annual_gross_earnings Vector of annual gross earnings.
#' @param ni_allowance National Insurance allowance.
#'
#' @return Vector of the National Insurance deductions.
#' @noRd
get_ni_deduction <- function(annual_gross_earnings, ni_allowance = 12570){
  stopifnot(is.numeric(annual_gross_earnings), annual_gross_earnings > 0, is.numeric(ni_allowance), ni_allowance > 0)

  base::ifelse(annual_gross_earnings <= ni_allowance, 0,
               base::ifelse(annual_gross_earnings <= 50270, (annual_gross_earnings - ni_allowance) * 0.08,
                            (50270 - ni_allowance) * 0.08 + (annual_gross_earnings - 50270) * 0.02))
}


#' Deduction 4: Student Loan Plan 2
#'
#' @param annual_gross_earnings Vector of the annual gross earnings.
#' @param slp2_allowance Student Loan Plan 2 allowance.
#'
#' @return Vector of the Student Loan Plan 2 deductions.
#' @noRd
get_slp2_deduction <- function(annual_gross_earnings, slp2_allowance = 27295) {
  stopifnot(is.numeric(annual_gross_earnings), annual_gross_earnings > 0, is.numeric(slp2_allowance), slp2_allowance > 0)
  base::ifelse(annual_gross_earnings <= slp2_allowance, 0, 0.09 * (annual_gross_earnings - slp2_allowance))
}


#' Deduction 5: Student Loan Postgrad
#'
#' @param annual_gross_earnings Vector of the annual gross earnings.
#' @param slpgrd_allowance Student Loan Postgrad allowance.
#'
#' @return Vector of the Student Loan Postgrad deductions.
#' @noRd
get_slpgrd_deduction <- function(annual_gross_earnings, slpgrd_allowance = 21000) {
  stopifnot(is.numeric(annual_gross_earnings), annual_gross_earnings > 0, is.numeric(slpgrd_allowance), slpgrd_allowance > 0)
  base::ifelse(annual_gross_earnings <= slpgrd_allowance, 0, 0.06 * (annual_gross_earnings - slpgrd_allowance))
}


#' Compile All Deductions & Apply Scaling Factors
#'
#' @param annual_gross_earnings Vector of the annual gross earnings.
#' @param scaling_factor Increase/decrease in annual gross earnings; must be greater than -1.
#' @param period Either a "year", "month" or "week".
#' @param alpha Should Alpha Pension Scheme be applied? TRUE/FALSE.
#' @param penstion_contr If alpha == FALSE, provide the pension contribution.
#' @param tax_allowance Tax allowance.
#' @param ni_allowance National Insurance allowance.
#' @param slp2_allowance Student Loan Plan 2 allowance.
#' @param slpgrd_allowance Student Loan Postgrad allowance.
#'
#' @return Data frame with all earnings and deductions for a given vector of gross earnings.
#' @noRd
get_df_income_calculator <- function(
    annual_gross_earnings,
    scaling_factor   = 0,
    period           = "year",
    alpha            = TRUE,
    penstion_contr   = 0.04,
    tax_allowance    = 12570,
    ni_allowance     = 12570,
    slp2_allowance   = 27295,
    slpgrd_allowance = 21000
) {
  stopifnot(is.numeric(scaling_factor), scaling_factor > -1, period %in% c("year", "month", "week"))

  scaling_factor <- base::rep(scaling_factor, times = base::length(annual_gross_earnings))
  alpha          <- base::rep(alpha, times = base::length(annual_gross_earnings))

  period_scaling        <- base::ifelse(period == "year", 1, base::ifelse(period == "month", 12, 52.1429))
  annual_gross_earnings <- base::ifelse(scaling_factor == 0, annual_gross_earnings, annual_gross_earnings * (1 + scaling_factor))

  # We assume all earnings are pensionable, i.e. discard any bonuses, one-offs, etc.
  pension_deduction <- base::ifelse(
    alpha == TRUE,
    get_pension_deduction(annual_gross_earnings, alpha = TRUE),
    get_pension_deduction(annual_gross_earnings, alpha = FALSE, contribution = penstion_contr)
  )

  annual_taxable_earnings <- annual_gross_earnings - pension_deduction
  tax_deduction           <- get_tax_deduction(annual_taxable_earnings, tax_allowance = tax_allowance)
  ni_deduction            <- get_ni_deduction(annual_gross_earnings, ni_allowance = ni_allowance)
  slp_deduction           <- get_slp2_deduction(annual_gross_earnings, slp2_allowance = slp2_allowance)
  slpgrd_deduction        <- get_slpgrd_deduction(annual_gross_earnings, slpgrd_allowance = slpgrd_allowance)
  net_earnings            <- annual_gross_earnings - (pension_deduction + tax_deduction + ni_deduction + slp_deduction + slpgrd_deduction)

  tibble::tibble(
    `Gross Earnings`        = annual_gross_earnings / period_scaling,
    Pension                 = pension_deduction / period_scaling,
    `National Insurance`    = ni_deduction / period_scaling,
    Tax                     = tax_deduction / period_scaling,
    `Student Loan Plan 2`   = slp_deduction / period_scaling,
    `Student Loan Postgrad` = slpgrd_deduction / period_scaling,
    `Net Earnings`          = net_earnings / period_scaling
  )
}


#' Draw the Income Calculator Table
#'
#' @param annual_gross_earnings The annual gross earnings; not a vector.
#' @param scaling_factor Increase/decrease in annual gross earnings; must be greater than -1.
#' @param period Either a "year", "month" or "week".
#' @param alpha Should Alpha Pension Scheme be applied? TRUE/FALSE.
#' @param penstion_contr If alpha == FALSE, provide the pension contribution.
#' @param tax_allowance Tax allowance.
#' @param ni_allowance National Insurance allowance.
#' @param slp2_allowance Student Loan Plan 2 allowance.
#' @param slpgrd_allowance Student Loan Postgrad allowance.
#'
#' @return Reactable table.
#' @noRd
table_income_calculator <- function(
    annual_gross_earnings,
    scaling_factor   = 0,
    period           = "month",
    alpha            = TRUE,
    penstion_contr   = 0.04,
    tax_allowance    = 12570,
    ni_allowance     = 12570,
    slp2_allowance   = 27295,
    slpgrd_allowance = 21000
) {
  stopifnot(base::length(annual_gross_earnings) == 1)

  data <- get_df_income_calculator(
    annual_gross_earnings = annual_gross_earnings,
    scaling_factor        = scaling_factor,
    period                = period,
    alpha                 = alpha,
    penstion_contr        = penstion_contr,
    tax_allowance         = tax_allowance,
    ni_allowance          = ni_allowance,
    slp2_allowance        = slp2_allowance,
    slpgrd_allowance      = slpgrd_allowance
  ) |>
    dplyr::mutate(Gross = `Gross Earnings`) |>
    tidyr::pivot_longer(
      cols      = -Gross,
      names_to  = "Earning/Deduction",
      values_to = "Value"
    ) |>
    dplyr::mutate(`% of Gross Earnings` = Value / Gross) |>
    dplyr::select(-Gross) |>
    #dplyr::filter(`Earning/Deduction` != "Gross Earnings") |>
    dplyr::left_join(col_palette_deductions, by = dplyr::join_by(`Earning/Deduction` == category))

  data |>
    reactable::reactable(
      compact   = TRUE,
      highlight = TRUE,
      sortable  = FALSE,
      rowStyle  = function(index) if (index == 7) list(fontWeight = "bold"),
      columns   = list(
        `Earning/Deduction` = reactable::colDef(
          cell     = reactablefmtr::pill_buttons(data = data, color_ref = "color"),
          minWidth = 210
        ),
        Value = reactable::colDef(format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE)),
        `% of Gross Earnings` = reactable::colDef(
          format   = reactable::colFormat(percent = TRUE, digits = 2),
          minWidth = 200
        ),
        color = reactable::colDef(show = FALSE)
      )
    )
}
