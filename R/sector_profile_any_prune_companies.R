#' Drop rows where the product info is `NA` & sector info is duplicated
#'
#' For each company, this function drops rows where the product information is
#' missing and the sector information is duplicated.
#'
#' @param data Typically a "sector profile" `*companies` dataframe.
#'
#' @family pre-processing helpers
#'
#' @return A dataframe with maybe fewer rows than the input `data`.
#' @export
#'
#' @examples
#' library(dplyr)
#'
#' # `example_companies()` is internal -- don't use it.
#' companies <- example_companies(
#'   row = 1:4,
#'   !!aka("id") := "a",
#'   !!aka("cluster") := c("b1", rep(NA, 3)),
#'   !!aka("uid") := c("c1", rep(NA, 3)),
#'   !!aka("tsector") := c("x", "x", "y", "y")
#' ) |>
#'   select(1:5)
#'
#' # Keep row 1: Has product info
#' # Drop row 2: Lacks product info and sector info is duplicated
#' # Keep row 3: Lacks product info but sector info is unique
#' # Drop row 4: Lacks product info and sector info is duplicated
#' companies
#'
#' sector_profile_any_prune_companies(companies)
sector_profile_any_prune_companies <- function(data) {
  check_prune_companies(data)

  data |>
    flag_companies() |>
    pick_companies()
}

check_prune_companies <- function(data) {
  crucial <- c(aka("id"), aka("cluster"), aka("uid"), aka("tsector"))
  check_crucial_names(data, crucial)

  invisible(data)
}

flag_companies <- function(data) {
  data |>
    group_by(.data$company_id, .data$tilt_sector) |>
    mutate(odd = ifelse(
      is.na(.data$clustered) & is.na(.data[[aka("uid")]]),
      TRUE,
      FALSE
    )) |>
    rowid_to_column() |>
    arrange(.data$odd, .by_group = TRUE) |>
    mutate(odd_and_first = .data$odd & row_number() == 1L) |>
    arrange(.data$rowid) |>
    select(-rowid()) |>
    mutate(keep = case_when(
      !.data$odd ~ TRUE,
      .data$odd & .data$odd_and_first ~ TRUE,
      .default = FALSE
    )) |>
    ungroup()
}

pick_companies <- function(data) {
  data |>
    filter(.data$keep) |>
    select(-"odd", -"odd_and_first", -"keep")
}
