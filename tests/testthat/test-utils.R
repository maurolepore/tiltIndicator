test_that("document_dataset() outputs the expected text", {
  expect_snapshot(document_dataset())
})

test_that("document_value() outputs the expected text", {
  expect_snapshot(document_value())
})

test_that("pad_column() pads as expected", {
  data <- tibble(x = c(1, 12, 123))
  out <- pad_column(data, "x", width = 2, pad = "0")
  expect_equal(out$x, c("01", "12", "123"))
})

test_that("pad_column() without the 'pattern' column errors gracefully", {
  expect_error(pad_column(tibble(x = 1), "y"), "lacks.*y")
})
