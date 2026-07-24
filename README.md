
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zmij

<!-- badges: start -->

[![R-CMD-check](https://github.com/nanxstats/zmij/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nanxstats/zmij/actions/workflows/R-CMD-check.yaml)
[![extendr](https://img.shields.io/badge/extendr-%5E0.9.0-276DC2)](https://extendr.github.io/extendr/extendr_api/)
<!-- badges: end -->

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
```

``` r
x <- c(pi, 0.1, -0, .Machine$double.xmin, .Machine$double.xmax)
x |> format_double()
#> [1] "3.141592653589793"       "0.1"                    
#> [3] "-0.0"                    "2.2250738585072014e-308"
#> [5] "1.7976931348623157e+308"
x |> format_double() |> parse_double() |> identical(x)
#> [1] TRUE
```

Missing and non-finite values are handled explicitly:

``` r
format_double(c(NA_real_, NaN, Inf, -Inf))
#> [1] NA     "NaN"  "inf"  "-inf"
```

`parse_double()` is also useful directly when correctly rounded
conversion is important, especially near the limits of the binary64
range:

``` r
parse_double(c("1.5", "3e-1", "5e-324", "1.7976931348623157e+308"))
#> [1]  1.500000e+00  3.000000e-01 4.940656e-324 1.797693e+308
```

Names, dimensions, and values are preserved through a round trip:

``` r
x <- c(pi = pi, tenth = 0.1)
x |> format_double()
#>                  pi               tenth 
#> "3.141592653589793"               "0.1"
x |> format_double() |> parse_double() |> identical(x)
#> [1] TRUE

x <- matrix(
  c(0.1, pi, 1e-6, 1e16),
  nrow = 2,
  dimnames = list(c("first", "second"), c("small", "large"))
)
x |> format_double()
#>        small               large  
#> first  "0.1"               "1e-6" 
#> second "3.141592653589793" "1e+16"
x |> format_double() |> parse_double() |> identical(x)
#> [1] TRUE
```
