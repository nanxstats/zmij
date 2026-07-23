# Format Double-Precision Values with zmij

Convert numeric values to decimal strings with the shortest significands
that recover the original IEEE 754 binary64 values when parsed using
round-to-nearest, ties-to-even rounding.

## Usage

``` r
format_double(x)
```

## Arguments

- x:

  A numeric vector, matrix, or array.

## Value

A character vector with the same length and shape as `x`. Names and
dimensions are preserved. Missing values remain `NA`; `NaN`, positive
infinity, and negative infinity become `"NaN"`, `"inf"`, and `"-inf"`,
respectively.

## Details

Integer inputs are converted to double precision before formatting. zmij
uses fixed notation for decimal exponents from -5 through 15 and
scientific notation outside that range. Other attributes, including
classes, are not retained because the returned values are character
strings.

## References

Zverovich V (2025). "Faster double-to-string conversion."
<https://vitaut.net/posts/2025/faster-dtoa/>.

Tolnay D. "zmij: A double-to-string conversion algorithm based on
Schubfach." <https://github.com/dtolnay/zmij>.

## Examples

``` r
x <- c(pi, 0.1, -0, .Machine$double.xmin, .Machine$double.xmax)
formatted <- format_double(x)
formatted
#> [1] "3.141592653589793"       "0.1"                    
#> [3] "-0.0"                    "2.2250738585072014e-308"
#> [5] "1.7976931348623157e+308"
identical(parse_double(formatted), x)
#> [1] TRUE

format_double(c(NA_real_, NaN, Inf, -Inf))
#> [1] NA     "NaN"  "inf"  "-inf"
```
