#' ONS Historical RPI Data
#'
#' A subset of the ONS RPI data.
#'
#' @format
#' A data frame with 73 rows and 2 columns:
#' \describe{
#'   \item{date}{Beginning of the month as date.}
#'   \item{rpi}{RPI in that period (in percentages).}
#' }
#' @source \url{https://www.ons.gov.uk/economy/inflationandpriceindices/timeseries/czbh/mm23}
"df_historical_rpi"



#' Example Monthly Transactions Data
#'
#' An artificial data with various transactions from March 2023 to the end of March 2024.
#' These transactions are always outgoing. Incoming transactions such as monthly
#' salary or money returns are not included.
#'
#' @format
#' A data frame with 1,053 rows and 5 columns:
#' \describe{
#'   \item{date}{Transaction date.}
#'   \item{category}{Transaction category.}
#'   \item{subcategory}{Transaction subcategory.}
#'   \item{description}{Transaction description.}
#'   \item{value}{Transaction value.}
#' }
"df_transactions"



#' Example Median UK Salary and Deductions
#'
#' An artificial data with annual salary set to the median UK earnings in that year.
#' Originally, and Excel file allowing monthly deduction control, populated
#' from the monthly payslips.
#'
#' @format
#' A data frame with 19 rows and 19 columns:
#' \describe{
#'   \item{date}{Covered period.}
#'   \item{annual_gross}{Annual gross income (in this example it's the median UK salary).}
#'   \item{monthly_gross}{Monthly gross income.}
#'   \item{monthly_net}{Monthly net (after subtracting all deductions) income.}
#'   \item{pensionable_earnings}{Earnings to calculate the pension deduction.}
#'   \item{pension_contribution}{Pension contribution.}
#'   \item{pension_deduction}{Pension deduction.}
#'   \item{national_insurance_allowance}{Monthly NI allowance (nothing is deducted below this value).}
#'   \item{national_insurance_contribution}{NI contribution, see \url{https://www.gov.uk/government/publications/rates-and-allowances-national-insurance-contributions/rates-and-allowances-national-insurance-contributions}.}
#'   \item{national_insurance_deduction}{NI deduction.}
#'   \item{tax_allowance}{Monthly tax allowance (no tax is paid on income below this value).}
#'   \item{tax_contribution}{Tax contribution.}
#'   \item{tax_deduction}{Tax deduction (it's calculated from the post-pension deduction income).}
#'   \item{student_loan_plan_2_allowance}{SLP2 allowance (a.k.a. plan 2 repayment threshold, see \url{https://www.gov.uk/repaying-your-student-loan/what-you-pay}).}
#'   \item{student_loan_plan_2_contribution}{SLP2 contribution.}
#'   \item{student_loan_plan_2_deduction}{SLP2 deduction.}
#'   \item{student_loan_postgrad_allowance}{SLP3 allowance (a.k.a. plan 3 repayment threshold, see \url{https://www.gov.uk/repaying-your-student-loan/what-you-pay}).}
#'   \item{student_loan_postgrad_contribution}{SLP3 contribution.}
#'   \item{student_loan_postgrad_deduction}{SLP3 deduction.}
#' }
"df_earnings"



#' Example Issues Data
#'
#' Originally an Excel data breaking down various issues, their characteristics,
#' importance and potential solutions. Highly subjective.
#'
#' @format
#' A data frame with 13 rows and 9 columns:
#' \describe{
#'   \item{id}{Issue identifier.}
#'   \item{issue}{Issue name.}
#'   \item{domain}{What the issue relate to.}
#'   \item{importance}{Subjective value of how important improving the issue is.}
#'   \item{scope}{Who/what does the issue impact/is related to.}
#'   \item{primary_obstacle}{A single biggest obstacle preventing from improving the issue.}
#'   \item{development_difficulty}{Subjective value of how difficult improving the issue is.}
#'   \item{score}{importance times development_difficulty.}
#'   \item{solution_method}{Potential solution to the issue.}
#' }
"df_issues"



#' Example Issues Relationships Data
#'
#' Originally an Excel data showing how much improving issue A could improve issue B.
#' It's subjective and aims to capture the interconnected nature between many problems.
#'
#' @format
#' A data frame with 25 rows and 5 columns:
#' \describe{
#'   \item{from}{ID issue A.}
#'   \item{from_name}{Look-up of the A ID from the \code{df_issues} data.}
#'   \item{to}{ID issue B.}
#'   \item{to_name}{Look-up of the B ID from the \code{df_issues} data.}
#'   \item{value}{How much improving A improves B?}
#' }
"df_issue_relationships"



#' Example Nutrition Data
#'
#' The \href{https://www.fatsecret.com}{FatSecret} app is brilliant for tracking
#' meals and nutrition. It allows exporting your data as either PDF or CSV.
#' \href{https://github.com/Admate8/appPersonal/tree/main/data-raw/nutrition.R}{\code{nutrition.R}}, in the app source code, contains a script
#' I run weekly to collect and clean my data, which I then combine with historical
#' data.
#'
#' @format
#' A data frame with 700 rows and 12 columns:
#' \describe{
#'   \item{type}{Meal category, e.g. breakfast or dinner.}
#'   \item{cals}{Meal calories.}
#'   \item{fat}{Meal fat (g, 1g =~ 9kcal).}
#'   \item{sat}{Meal saturates (g).}
#'   \item{carbs}{Meal carbohydrates (g, 1g =~ 4kcal).}
#'   \item{fibre}{Meal fibre (g).}
#'   \item{sugar}{Meal sugars (g).}
#'   \item{prot}{Meal proteins (g, 1g =~ 4kcal).}
#'   \item{sod}{Mead sodium (mg).}
#'   \item{chol}{Meal cholesterol (g).}
#'   \item{potassium}{Meal potassium (mg).}
#'   \item{date}{Meal date.}
#' }
"df_nutrition"



#' Example Exercises Data
#'
#' Artificial exercises tracker data, originally an Excel file. Simple way of
#' seeing progress over time. The alternative would be to use some apps and export
#' the data instead.
#'
#' @format
#' A data frame with 155 rows and 10 columns:
#' \describe{
#'   \item{date}{Date an exercises took place.}
#'   \item{exercise}{Exercise name.}
#'   \item{type}{Exercise type.}
#'   \item{category}{Exercise category.}
#'   \item{weight}{Total weight.}
#'   \item{sets}{Number of sets.}
#'   \item{reps}{Number of repetitions in a single set.}
#'   \item{reps_min}{Minimum number or repetitions.}
#'   \item{reps_max}{Maximum number or repetitions to increase weight.}
#'   \item{rest}{Rest time between sets.}
#' }
"df_exercises"



#' Example Exercises Rating Data
#'
#' I like to measure how I feel after exercising and this data stores this info.
#'
#' @format
#' A data frame with 69 rows and 3 columns:
#' \describe{
#'   \item{date}{Date an activity took place.}
#'   \item{rating}{How did you feel after the activity?}
#'   \item{type}{Type of activity.}
#' }
"df_rating"



#' Example Measurements Data
#'
#' Artificial measurements data over time.
#'
#' @format
#' A data frame with 20 rows and 13 columns:
#' \describe{
#'   \item{date}{Measurement date.}
#'   \item{neck}{Neck measurement (cm).}
#'   \item{shoulders}{Shoulder measurement (cm).}
#'   \item{chest}{Chest measurement (cm).}
#'   \item{bicep}{Bicep measurement (cm).}
#'   \item{waist}{Waist measurement (cm).}
#'   \item{hip}{Hip measurement (cm).}
#'   \item{thigh}{Thigh measurement (cm).}
#'   \item{weight}{Weight measurement (kg).}
#'   \item{bmi}{BMI measurement.}
#'   \item{bmr}{Basal metabolic rate (calories).}
#'   \item{waist_to_hip_ratio}{waist / hip.}
#'   \item{target_calories}{1.1 * bmr.}
#' }
"df_measurements"



#' Artificial Student Loan Repayments Data
#'
#' Each financial year SLC sends a letter detailing student loan repayments and
#' interest accumulated over time. You can find example letters in the source code:
#' \href{https://github.com/Admate8/appPersonal/tree/main/inst/extdata}{\code{extdata}}.
#' \href{https://github.com/Admate8/appPersonal/tree/main/data-raw/student_loan_letters.R}{\code{student_loan_letters.R}} contains a script
#' allowing you to scrape this data and clean it. \code{df_loan_repays} data is
#' the result of such preprocessing.
#'
#' @format
#' A data frame with 66 rows and 11 columns:
#' \describe{
#'   \item{date}{Begining of the month date.}
#'   \item{interest_rate_ug}{Interest rate for undergraduate loan in that month.}
#'   \item{interest_rate_pg}{Interest rate for postgraduate loan in that month.}
#'   \item{outlay_ug}{Money sent to the university covering your undergarduate tuition fees.}
#'   \item{outlay_pg}{Money sent to the university covering your postgarduate tuition fees.}
#'   \item{interest_ug}{Interest accrued for undergraduate loan in that month.}
#'   \item{interest_pg}{Interest accrued for postgraduate loan in that month.}
#'   \item{repays_ug}{Total undergraduate repayments (PAYE + overseas + voluntary) in that month.}
#'   \item{repays_pg}{Total postgraduate repayments (PAYE + overseas + voluntary) in that month.}
#'   \item{balance_ug}{Total undergraduate loan balance at the end of that month.}
#'   \item{balance_pg}{Total postgraduate loan balance at the end of that month.}
#' }
"df_loan_repays"
