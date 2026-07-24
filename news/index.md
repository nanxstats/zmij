# Changelog

## zmij 0.1.0

### New features

- Added
  [`format_double()`](https://nanx.me/zmij/reference/format_double.md)
  for vectorized, round-trip-safe formatting of double-precision values
  using the vendored Rust `zmij` implementation
  ([\#1](https://github.com/nanxstats/zmij/issues/1)).
- Added
  [`parse_double()`](https://nanx.me/zmij/reference/parse_double.md) for
  correctly rounded conversion of decimal strings back to
  double-precision values
  ([\#1](https://github.com/nanxstats/zmij/issues/1)).
- Numeric and character vectors, matrices, and arrays are supported.
  Names, dimensions, and dimension names are preserved, with explicit
  handling of missing values, `NaN`, infinities, signed zero, and empty
  inputs.
