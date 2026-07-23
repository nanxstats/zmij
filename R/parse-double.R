#' Parse Double-Precision Strings
#'
#' Parse decimal strings into IEEE 754 binary64 values using Rust's correctly
#' rounded parser. This is the inverse of [format_double()] for every finite
#' double.
#'
#' @param x A character vector, matrix, or array.
#'
#' @return A double vector with the same length and shape as `x`. Names and
#'   dimensions are preserved. Missing strings remain `NA_real_`.
#'
#' @details
#' The parser accepts decimal and scientific notation, along with `"NaN"`,
#' `"inf"`, and `"-inf"`. Leading or trailing whitespace and other invalid
#' strings cause an error that identifies the first invalid element.
#'
#' Using `parse_double()` avoids platform-specific edge cases in R's built-in
#' decimal parser near the limits of the binary64 range.
#'
#' @examples
#' x <- c(pi, 0.1, -0, .Machine$double.xmin, .Machine$double.xmax)
#' identical(parse_double(format_double(x)), x)
#'
#' parse_double(c("1.5", "3e-1", NA_character_, "inf"))
#'
#' @export
parse_double <- function(x) {
  if (!is.character(x)) {
    stop("`x` must be a character vector.", call. = FALSE)
  }

  output <- parse_double_impl(x)
  .restore_shape(output, x)
}

.restore_shape <- function(output, input) {
  if (is.null(dim(input))) {
    names(output) <- names(input)
  } else {
    dim(output) <- dim(input)
    dimnames(output) <- dimnames(input)
  }

  output
}
