test_that("finite values use zmij representations", {
  x <- c(
    0,
    -0,
    1,
    -1,
    1.234,
    0.3,
    1e-5,
    1e-6,
    1e15,
    1e16,
    5e-324,
    .Machine$double.xmax
  )

  expect_identical(
    format_double(x),
    c(
      "0.0",
      "-0.0",
      "1.0",
      "-1.0",
      "1.234",
      "0.3",
      "0.00001",
      "1e-6",
      "1000000000000000.0",
      "1e+16",
      "5e-324",
      "1.7976931348623157e+308"
    )
  )
})

test_that("finite values round trip exactly", {
  set.seed(42)
  x <- c(
    pi,
    -pi,
    .Machine$double.eps,
    .Machine$double.xmin,
    .Machine$double.xmax,
    5e-324,
    runif(1000, -1, 1) * 10^sample(-300:300, 1000, replace = TRUE)
  )

  expect_identical(parse_double(format_double(x)), x)

  negative_zero <- parse_double(format_double(-0))
  expect_identical(1 / negative_zero, -Inf)
})

test_that("missing and non-finite values are handled explicitly", {
  output <- format_double(c(NA_real_, NaN, Inf, -Inf))

  expect_true(is.na(output[[1L]]))
  expect_identical(output[-1L], c("NaN", "inf", "-inf"))
  expect_false(is.na(output[[2L]]))
})

test_that("formatted special values parse back", {
  x <- c(NA_real_, NaN, Inf, -Inf)
  output <- parse_double(format_double(x))

  expect_true(is.na(output[[1L]]) && !is.nan(output[[1L]]))
  expect_true(is.nan(output[[2L]]))
  expect_identical(output[3:4], c(Inf, -Inf))
})

test_that("integer vectors are supported", {
  expect_identical(
    format_double(c(value = 1L, missing = NA_integer_)),
    c(value = "1.0", missing = NA_character_)
  )
})

test_that("names and dimensions are preserved", {
  named <- c(first = 1, second = 2)
  expect_identical(names(format_double(named)), names(named))

  matrix_input <- matrix(
    c(1, 2, 3, 4),
    nrow = 2,
    dimnames = list(c("a", "b"), c("x", "y"))
  )
  matrix_output <- format_double(matrix_input)

  expect_identical(dim(matrix_output), dim(matrix_input))
  expect_identical(dimnames(matrix_output), dimnames(matrix_input))
  expect_identical(
    unname(as.vector(matrix_output)),
    c("1.0", "2.0", "3.0", "4.0")
  )
})

test_that("empty vectors work and invalid inputs fail clearly", {
  expect_identical(format_double(numeric()), character())
  expect_identical(parse_double(character()), double())
  expect_error(
    format_double(NULL),
    "`x` must be a numeric vector",
    fixed = TRUE
  )
  expect_error(
    format_double("1"),
    "`x` must be a numeric vector",
    fixed = TRUE
  )
  expect_error(
    format_double(TRUE),
    "`x` must be a numeric vector",
    fixed = TRUE
  )
  expect_error(
    format_double(1 + 0i),
    "`x` must be a numeric vector",
    fixed = TRUE
  )
})

test_that("the parser accepts decimal input and rejects invalid input", {
  expect_identical(
    parse_double(c("1.5", "3e-1", NA_character_, "inf", "-inf", "NaN")),
    c(1.5, 0.3, NA_real_, Inf, -Inf, NaN)
  )
  expect_error(
    parse_double(c("1", "not-a-number")),
    "`x[[2]]` is not a valid floating-point string",
    fixed = TRUE
  )
  expect_error(
    parse_double(" 1"),
    "`x[[1]]` is not a valid floating-point string",
    fixed = TRUE
  )
  expect_error(
    parse_double(1),
    "`x` must be a character vector",
    fixed = TRUE
  )
})

test_that("the parser preserves names and dimensions", {
  named <- c(first = "1.0", second = "2.0")
  expect_identical(names(parse_double(named)), names(named))

  matrix_input <- matrix(
    c("1.0", "2.0", "3.0", "4.0"),
    nrow = 2,
    dimnames = list(c("a", "b"), c("x", "y"))
  )
  matrix_output <- parse_double(matrix_input)

  expect_identical(dim(matrix_output), dim(matrix_input))
  expect_identical(dimnames(matrix_output), dimnames(matrix_input))
  expect_identical(unname(as.vector(matrix_output)), c(1, 2, 3, 4))
})
