
# Data & Code for the Earnings & Deductions Check Table -------------------


#' Prepare Data for the Earnings Check Table
#'
#' @param selected_month Date of the form "YYYY-MM-DD", e.g. "2023-01-01".
#' @param df_earnings Data with monthly earnings. See \code{appPersonal::df_earnings} as an example.
#' @noRd
get_df_earnings_check <- function(selected_month, df_earnings) {

  df_earnings_check <- df_earnings |>
    dplyr::filter(date == selected_month) |>
    dplyr::mutate(
      pension_calc               = (pensionable_earnings / 12) * pension_contribution,
      national_insurance_calc    = national_insurance_contribution * (monthly_gross - national_insurance_allowance),
      tax_calc                   = tax_contribution * ((1 - pension_contribution) * monthly_gross - tax_allowance),
      student_loan_plan_2_calc   = student_loan_plan_2_contribution * (monthly_gross - student_loan_plan_2_allowance),
      student_loan_postgrad_calc = student_loan_postgrad_contribution * (monthly_gross - student_loan_postgrad_allowance),
      monthly_net_calc           = monthly_gross - (pension_calc + national_insurance_calc + tax_calc + student_loan_plan_2_calc + student_loan_postgrad_calc),
      monthly_gross_calc         = annual_gross / 12,

      pension_col = dplyr::case_when(
        abs(pension_deduction - pension_calc) <= 1 ~ "green",
        pension_calc > pension_deduction ~ "orange",
        TRUE ~ "red"
      ),
      national_insurance_col = dplyr::case_when(
        abs(national_insurance_deduction - national_insurance_calc) <= 1 ~ "green",
        national_insurance_calc > national_insurance_deduction ~ "orange",
        TRUE ~ "red"
      ),
      tax_col = dplyr::case_when(
        abs(tax_deduction - tax_calc) <= 1 ~ "green",
        tax_calc > tax_deduction ~ "orange",
        TRUE ~ "red"
      ),
      student_loan_plan_2_col = dplyr::case_when(
        abs(student_loan_plan_2_deduction - student_loan_plan_2_calc) <= 1 ~ "green",
        student_loan_plan_2_calc > student_loan_plan_2_deduction ~ "orange",
        TRUE ~ "red"
      ),
      student_loan_postgrad_col = dplyr::case_when(
        abs(student_loan_postgrad_deduction - student_loan_postgrad_calc) <= 1 ~ "green",
        student_loan_postgrad_calc > student_loan_postgrad_deduction ~ "orange",
        TRUE ~ "red"
      ),
      monthly_gross_col = dplyr::case_when(
        abs(monthly_gross - monthly_gross_calc) <= 10 ~ "green",
        monthly_gross_calc > monthly_gross ~ "red",
        TRUE ~ "orange"
      ),
      monthly_net_col = dplyr::case_when(
        abs(monthly_net - monthly_net) <= 10 ~ "green",
        monthly_net > monthly_net ~ "red",
        TRUE ~ "orange"
      )
    )

  df_earnings_check_reshaped <- df_earnings_check |>
    dplyr::select(-date, -annual_gross, -pensionable_earnings, -dplyr::contains("col")) |>
    tidyr::pivot_longer(
      cols     = tidyselect::where(is.numeric),
      names_to = "earning_deduction",
    ) |>
    dplyr::mutate(
      category = dplyr::case_when(
        base::grepl("contribution", earning_deduction) ~ "contribution",
        base::grepl("allowance", earning_deduction) ~ "allowance",
        base::grepl("calc", earning_deduction) ~ "calc",
        TRUE ~ "actual_value"
      ),
      earning_deduction = base::sub("_contribution|_allowance|_deduction|_calc", "", earning_deduction)
    ) |>
    tidyr::pivot_wider(
      names_from  = "category",
      values_from = "value"
    )

  df_earnings_check_reshaped |>
    # Join the colours indicating the change in respect to the formula
    dplyr::left_join(
      df_earnings_check |>
        dplyr::select(dplyr::contains("col")) |>
        tidyr::pivot_longer(
          cols      = dplyr::everything(),
          names_to  = "earning_deduction",
          values_to = "col_change"
        ) |>
        dplyr::mutate(earning_deduction = base::sub("_col", "", earning_deduction)),
      by = dplyr::join_by(earning_deduction)
    ) |>
    # Rename values in the first column to look more presentable in the table
    dplyr::mutate(earning_deduction = dplyr::case_when(
      earning_deduction == "monthly_gross"         ~ "Gross Earnings",
      earning_deduction == "monthly_net"           ~ "Net Earnings",
      earning_deduction == "pension"               ~ "Pension",
      earning_deduction == "national_insurance"    ~ "National Insurance",
      earning_deduction == "tax"                   ~ "Tax",
      earning_deduction == "student_loan_plan_2"   ~ "Student Loan Plan 2",
      earning_deduction == "student_loan_postgrad" ~ "Student Loan Postgrad"
    )) |>

    # Join the earning_deduction colours for pills
    dplyr::left_join(col_palette_deductions, by = dplyr::join_by(earning_deduction == category)) |>
    dplyr::arrange(earning_deduction == "Net Earnings") |>
    dplyr::select(earning_deduction, actual_value, calc, contribution, allowance, col_change, color)
}


#' Draw the Earnings Check Table
#'
#' @inheritParams appPersonal::get_df_earnings_check
#' @noRd
table_earnings_check <- function(selected_month, df_earnings) {
  data <- get_df_earnings_check(selected_month, df_earnings)
  data |>
    reactable::reactable(
      compact   = TRUE,
      highlight = TRUE,
      sortable  = FALSE,
      wrap      = TRUE,
      rowStyle  = function(index) if (index == 7) list(fontWeight = "bold"),
      columns   = list(
        earning_deduction = reactable::colDef(
          name     = "Earning/Deduction",
          cell     = reactablefmtr::pill_buttons(data = data, color_ref = "color"),
          minWidth = 210
        ),
        actual_value = reactable::colDef(name = "Actual Value", format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE)),
        contribution = reactable::colDef(name = "Contribution", format = reactable::colFormat(percent = TRUE), minWidth = 115),
        allowance    = reactable::colDef(name = "Allowance", format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE)),
        calc         = reactable::colDef(
          name   = "Validation",
          format = reactable::colFormat(currency = "GBP", digits = 2, separators = TRUE),
          style  = function(value, index) {
            if (data$col_change[index] == "red") col <- "red"
            else if (data$col_change[index] == "orange") col <- "orange"
            else if (data$col_change[index] == "green") col <- "green"
            else color <- "black"
            list(color = col)
          }
        ),
        col_change = reactable::colDef(show = FALSE),
        color      = reactable::colDef(show = FALSE)
      )
    )
}
