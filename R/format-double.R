#' Format Double-Precision Values with zmij
#'
#' Convert numeric values to decimal strings with the shortest significands
#' that recover the original IEEE 754 binary64 values when parsed using
#' round-to-nearest, ties-to-even rounding.
#'
#' @param x A numeric vector, matrix, or array.
#'
#' @return A character vector with the same length and shape as `x`. Names and
#'   dimensions are preserved. Missing values remain `NA`; `NaN`, positive
#'   infinity, and negative infinity become `"NaN"`, `"inf"`, and `"-inf"`,
#'   respectively.
#'
#' @details
#' Integer inputs are converted to double precision before formatting. zmij
#' uses fixed notation for decimal exponents from -5 through 15 and scientific
#' notation outside that range. Other attributes, including classes, are not
#' retained because the returned values are character strings.
#'
#' @references
#' Zverovich V (2025). "Faster double-to-string conversion."
#' <https://vitaut.net/posts/2025/faster-dtoa/>.
#'
#' Tolnay D. "zmij: A double-to-string conversion algorithm based on Schubfach."
#' <https://github.com/dtolnay/zmij>.
#'
#' @examples
#' x <- c(pi, 0.1, -0, .Machine$double.xmin, .Machine$double.xmax)
#' formatted <- format_double(x)
#' formatted
#' identical(parse_double(formatted), x)
#'
#' format_double(c(NA_real_, NaN, Inf, -Inf))
#'
#' @export
format_double <- function(x) {
  if (!is.numeric(x)) {
    stop("`x` must be a numeric vector.", call. = FALSE)
  }

  output <- format_double_impl(as.double(x))
  .restore_shape(output, x)
}
