# zmij

zmij converts double-precision floating-point values to decimal strings
with the shortest significands needed for round-trip recovery. It
provides a vectorized R interface to the
[zmij](https://github.com/dtolnay/zmij) Rust crate, a port of Victor
Zverovich’s [zmij algorithm](https://github.com/vitaut/zmij).

## Installation

You can install the development version of zmij from GitHub with:

``` r

# install.packages("pak")
pak::pak("nanxstats/zmij")
```

## Usage

Format a numeric vector:

``` r

library(zmij)

x <- c(pi, 0.1, -0, .Machine$double.xmin, .Machine$double.xmax)
text <- format_double(x)
text
#> [1] "3.141592653589793"       "0.1"                    
#> [3] "-0.0"                    "2.2250738585072014e-308"
#> [5] "1.7976931348623157e+308"
identical(parse_double(text), x)
#> [1] TRUE
```

Missing and non-finite values are handled explicitly:

``` r

format_double(c(NA_real_, NaN, Inf, -Inf))
#> [1] NA     "NaN"  "inf"  "-inf"
```

[`parse_double()`](https://nanx.me/zmij/reference/parse_double.md) is
also useful directly when correctly rounded conversion is important,
especially near the limits of the binary64 range:

``` r

parse_double(c("1.5", "3e-1", "5e-324", "1.7976931348623157e+308"))
#> [1]  1.500000e+00  3.000000e-01 4.940656e-324 1.797693e+308
```

Names and dimensions are preserved:

``` r

format_double(matrix(c(0.1, pi, 1e-6, 1e16), nrow = 2))
#>      [,1]                [,2]   
#> [1,] "0.1"               "1e-6" 
#> [2,] "3.141592653589793" "1e+16"
```
