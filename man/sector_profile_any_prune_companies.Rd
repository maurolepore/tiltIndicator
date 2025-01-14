% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sector_profile_any_prune_companies.R
\name{sector_profile_any_prune_companies}
\alias{sector_profile_any_prune_companies}
\title{Drop rows where the product info is \code{NA} & sector info is duplicated}
\usage{
sector_profile_any_prune_companies(data)
}
\arguments{
\item{data}{Typically a "sector profile" \verb{*companies} dataframe.}
}
\value{
A dataframe with maybe fewer rows than the input \code{data}.
}
\description{
For each company, this function drops rows where the product information is
missing and the sector information is duplicated.
}
\examples{
library(dplyr)

# `example_companies()` is internal -- don't use it.
companies <- example_companies(
  row = 1:4,
  !!aka("id") := "a",
  !!aka("cluster") := c("b1", rep(NA, 3)),
  !!aka("uid") := c("c1", rep(NA, 3)),
  !!aka("tsector") := c("x", "x", "y", "y")
) |>
  select(1:5)

# Keep row 1: Has product info
# Drop row 2: Lacks product info and sector info is duplicated
# Keep row 3: Lacks product info but sector info is unique
# Drop row 4: Lacks product info and sector info is duplicated
companies

sector_profile_any_prune_companies(companies)
}
\seealso{
Other pre-processing helpers: 
\code{\link{sector_profile_any_pivot_type_sector_subsector}()},
\code{\link{sector_profile_any_prepare_scenario}()}
}
\concept{pre-processing helpers}
