# Global colours ----
spinners_col  <- "#023C40"
primary_col   <- "#023C40"
secondary_col <- "#C3979F"

table_header_bg_col <- "#023C40"
table_header_col    <- "white"

app_theme <- bslib::bs_theme(
  preset  = "shiny",
  version = 5,
  "nav-link-hover-color" = primary_col,
  "navbar-light-bg"      = primary_col,
  "primary"              = secondary_col
)


# Global palettes ----
# Order at which the categories appear in the palettes tibbles *matters*
# as it is easier to set it up here rather than individually in each echart plot
col_palette_categories <- tibble::tribble(
  ~category,     ~color,
  "Bills",       "#3f4448",
  "Investments", "#d69484",
  "Savings",     "#936162",
  "Transport",   "#eae1da",
  "Groceries",   "#f9d887",
  "Shopping",    "#4a6985",
  "Leisure",     "#f2bed1",
  "Hobbies",     "#d83700",
  "Holiday",     "#f08d43",
  "Other",       "#dce4eb",
  "Remainder",   "#d3d3d3",
  "Total",       "#ffffff"
)

col_palette_categories_wider <- tibble::tribble(
  ~category,      ~color,
  "Net Earnings", "#004777",
  "Expenses",     "#788475",
  "Assets",       "#EFD28D",
  "Net Income",   "#996888"
)

col_palette_deductions <- tibble::tribble(
  ~category,               ~color,
  "Gross Earnings",        "#EF476F",
  "Net Earnings",          "#0B5563",
  "Tax",                   "#936162",
  "Pension",               "#FFD166",
  "National Insurance",    "#B0A990",
  "Student Loan Plan 2",   "#5299D3",
  "Student Loan Postgrad", "#A2BCE0"
)

col_palette_nutritions <- tibble::tribble(
  ~category,      ~color,
  "Calories",     "#FFC09F",
  "Carbohydrate", "#0C1B33",
  "Protein",      "#7A306C",
  "Fat",          "#B2AA8E",
  "Saturates",    "#6C464F",
  "Fibre",        "#9E768F",
  "Sugar",        "#9FA4C4",
  "Sodium",       "#3A606E",
  "Cholesterol",  "#FFD166",
  "Potassium",    "#828E82",
  "Total",        "#EF476F"
)
