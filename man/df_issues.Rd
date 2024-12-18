% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{df_issues}
\alias{df_issues}
\title{Example Issues Data}
\format{
A data frame with 13 rows and 9 columns:
\describe{
  \item{id}{Issue identifier.}
  \item{issue}{Issue name.}
  \item{domain}{What the issue relate to.}
  \item{importance}{Subjective value of how important improving the issue is.}
  \item{scope}{Who/what does the issue impact/is related to.}
  \item{primary_obstacle}{A single biggest obstacle preventing from improving the issue.}
  \item{development_difficulty}{Subjective value of how difficult improving the issue is.}
  \item{score}{importance times development_difficulty.}
  \item{solution_method}{Potential solution to the issue.}
}
}
\usage{
df_issues
}
\description{
Originally an Excel data breaking down various issues, their characteristics,
importance and potential solutions. Highly subjective.
}
\keyword{datasets}
