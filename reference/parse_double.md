# Parse Double-Precision Strings

Parse decimal strings into IEEE 754 binary64 values using Rust's
correctly rounded parser. This is the inverse of
[`format_double()`](https://nanx.me/zmij/reference/format_double.md) for
every finite double.

## Usage

``` r
parse_double(x)
```

## Arguments

- x:

  A character vector, matrix, or array.

## Value

A double vector with the same length and shape as `x`. Names and
dimensions are preserved. Missing strings remain `NA_real_`.

## Details

The parser accepts decimal and scientific notation, along with `"NaN"`,
`"inf"`, and `"-inf"`. Leading or trailing whitespace and other invalid
strings cause an error that identifies the first invalid element.

Using `parse_double()` avoids platform-specific edge cases in R's
built-in decimal parser near the limits of the binary64 range.

## Examples

``` r
x <- c(pi, 0.1, -0, .Machine$double.xmin, .Machine$double.xmax)
identical(parse_double(format_double(x)), x)
#> [1] TRUE

parse_double(c("1.5", "3e-1", NA_character_, "inf"))
#> [1] 1.5 0.3  NA Inf
```
