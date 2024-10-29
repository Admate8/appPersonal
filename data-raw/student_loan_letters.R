# Code to import student loan data from PDF letters


file_path_sfal_1823 <- file.path(here::here(), "inst/extdata/example_student_finance_letter_fy_2018_23.pdf")
file_path_sfal_2324 <- file.path(here::here(), "inst/extdata/example_student_finance_letter_fy_2023_24.pdf")
# New files need to be added here and to the preprocessing pipeline at the bottom (lines 133 and 142)
# file_path_sfal_2425 <- ...



#' Split Student Finance Annual Letter (SFAL) into UG and PG Loans
#'
#' @param file_path File path to the statement.
#'
#' @return List of raw tables relating to either UG or PG loans.
#' @noRd
split_loan_repays <- function(file_path) {

  stopifnot("Check the file path" = file.exists(file.path(file_path)))
  df_loans_repays_all <- pdftools::pdf_text(file_path)

  # The first page contains the summary information - isolate it here
  df_loan_repays_summary   <- df_loans_repays_all[[1]]

  # "PGL" always begins on a new page and continues until the end of the document
  # Detect on which page this string occurs to isolate PG repayments
  page_with_pg_loans_start <- stringr::str_which(df_loans_repays_all, "PGL")[2]
  page_with_pg_loans_end   <- length(df_loans_repays_all)
  df_loan_repays_pg        <- df_loans_repays_all[page_with_pg_loans_start:page_with_pg_loans_end]

  # "PLAN2" always begins on the second page and ends before "PGL" begins
  df_loan_repays_ug        <- df_loans_repays_all[2:(page_with_pg_loans_start - 1)]

  return(list(
    "summary" = df_loan_repays_summary, # returned but currently not in use
    "ug"      = df_loan_repays_ug,
    "pg"      = df_loan_repays_pg
  ))
}



#' Convert raw PDF text UG/PG Loan Repayments into a Tibble
#'
#' @param raw_text Text scrapped from the PDF file containing UG/PG table.
#'
#' @return Tibble for further processing.
#' @noRd
clean_loan_repays <- function(raw_text) {

  # Convert to a matrix and split by spaces
  text <- raw_text |>
    stringr::str_split("\\n", simplify = TRUE) |>
    stringr::str_replace_all("\\s{3,}", "|")

  # Remove "" from the string
  text <- text[nchar(text) > 0]

  # Filter only those characters starting with a date - isolate the table
  text <- text[grepl("^\\d{2}/\\d{2}/\\d{4}", text)]

  # Convert the text to a tibble and clean
  text |>
    textConnection() |>
    utils::read.csv(sep = "|", col.names = c("date", "transaction", "value"), header = FALSE) |>
    tibble::as_tibble() |>

    # Correct mistakes in the 'date' column:
    # usually new entries are separated by at least two spaces, but if that's not the case
    # we need to split the text into appropriate columns manually
    dplyr::mutate(
      value       = as.numeric(ifelse(nchar(date) == 10, value, transaction)),
      transaction = ifelse(nchar(date) == 10, transaction, stringr::str_trim(substr(date, 11, nchar(date)))),
      date        = ifelse(nchar(date) == 10, date, substr(date, 1, 10))
    ) |>

    # Split the interest rate and the transaction type into two columns and
    # convert dates into the standard format
    dplyr::mutate(
      interest_rate = as.numeric(stringr::str_extract(transaction, "\\d+\\.\\d+|\\d+")),
      transaction   = stringr::str_trim(ifelse(stringr::str_detect(transaction, "\\d"), stringr::str_extract(transaction, "^[^\\d]*"), transaction)),
      date          = lubridate::dmy(date),
      transaction   = ifelse(grepl("Loan Payment", transaction), "Loan Payment", transaction)
    ) |>
    # Make sure "Opening balance" is removed to enable joining multiple letters
    dplyr::filter(transaction != "Opening balance") |>
    dplyr::arrange(date, dplyr::desc(transaction)) |>
    # Clean the results
    dplyr::mutate(
      date          = lubridate::floor_date(date, unit = "months"),
      interest_rate = ifelse(is.na(interest_rate), dplyr::lead(interest_rate), interest_rate),
      transaction   = dplyr::case_when(
        transaction == "Loan Payment" ~ "outlay",
        transaction == "Interest"     ~ "interest",
        TRUE                          ~ "repays"
      )
    ) |>
    tidyr::pivot_wider(
      names_from  = "transaction",
      values_from = "value",
      values_fill = 0L
    ) |>
    dplyr::mutate(repays = -repays)
}



#' Calculate Loan Balance
#'
#' @param df Result of the \code{reshape_loan_repays} function.
#'
#' @noRd
calculate_loan_balance <- function(df) {

  # Initiate balance calculations
  df$balance <- c(df$outlay[1] + df$repays[1] + df$interest[1], rep(0, nrow(df) - 1))

  for (i in 2:nrow(df)) {

    # Calculate historical balance
    balance_prev <- df$balance[i - 1]
    df$balance[i] <- balance_prev + df$outlay[i] + df$repays[i] + df$interest[i]
  }

  return(df)
}



df_loan_repays_ug <- c(
  split_loan_repays(file_path_sfal_1823)$ug,
  split_loan_repays(file_path_sfal_2324)$ug
  # split_loan_repays(file_path_sfal_2425)$ug
) |>
  clean_loan_repays() |>
  calculate_loan_balance() |>
  dplyr::rename_with(~ paste0(.x, "_ug"), .cols = -date)

df_loan_repays_pg <- c(
  split_loan_repays(file_path_sfal_1823)$pg,
  split_loan_repays(file_path_sfal_2324)$pg
  # split_loan_repays(file_path_sfal_2425)$pg
) |>
  clean_loan_repays() |>
  calculate_loan_balance() |>
  dplyr::rename_with(~ paste0(.x, "_pg"), .cols = -date)

df_loan_repays <- dplyr::left_join(
  x = df_loan_repays_ug,
  y = df_loan_repays_pg,
  by = "date"
)

usethis::use_data(df_loan_repays, overwrite = TRUE)
