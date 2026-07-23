# AGENTS.md

## Package scope and public API

- This package exposes the vendored Rust `zmij` crate through extendr.
- Keep the public interface vectorized and R-native:
  - [`format_double()`](https://nanx.me/zmij/reference/format_double.md)
    accepts numeric vectors, matrices, and arrays.
  - [`parse_double()`](https://nanx.me/zmij/reference/parse_double.md)
    accepts character vectors, matrices, and arrays.
  - Preserve names, dimensions, and dimension names, but do not copy
    classes or unrelated attributes across a type conversion.
- Preserve R missing values and distinguish `NA_real_` from `NaN`.
  Non-finite values format as `"NaN"`, `"inf"`, and `"-inf"`.
- zmij uses fixed notation for decimal exponents -5 through 15 and
  scientific notation outside that range. Scientific exponents include a
  plus sign when positive. Preserve signed zero (`"-0.0"`).
- Verify round trips with
  [`parse_double()`](https://nanx.me/zmij/reference/parse_double.md),
  not [`as.double()`](https://rdrr.io/r/base/double.html). Base R
  decimal parsing can fail near binary64 boundaries on some platforms;
  this was observed for `.Machine$double.xmin`, `.Machine$double.xmax`,
  and other extreme values on R 4.6 for macOS.

## R and Rust implementation

- Put public validation, shape restoration, and roxygen2 documentation
  in `R/`. Keep extendr-facing implementations in `src/rust/src/lib.rs`.
- Rust functions exposed only as implementation details must use
  `@keywords internal`. Register every new Rust function in the
  `extendr_module!` block.
- `R/extendr-wrappers.R` and `src/entrypoint.c` are generated artifacts.
  Do not edit them by hand.
- The local Rust package and the upstream crate are both named `zmij`.
  Keep the dependency aliased as `zmij-rs` in `Cargo.toml`.
- Upstream zmij 1.0.23 requires Rust 1.71. Keep Cargo `rust-version`,
  DESCRIPTION `SystemRequirements`, `Cargo.lock`, and the vendor archive
  synchronized.

## Documentation and tests

- After changing R documentation or Rust exports, run:

  ``` r

  devtools::document()
  ```

- Put concise examples in `README.Rmd`, then regenerate `README.md` with
  `devtools::build_readme()`. A vignette is unnecessary for the current
  API.

- Use testthat. Cover exact notation, finite round trips, signed zero,
  subnormals and binary64 limits, missing and non-finite values, integer
  input, empty vectors, validation errors, parser errors, and shape
  preservation.

- Check Rust formatting with:

  ``` sh
  cargo fmt --manifest-path src/rust/Cargo.toml --all -- --check
  ```

## Vendoring, licensing, and CRAN

- CRAN builds must not access the network. After any Cargo dependency or
  lock file change, run:

  ``` r

  rextendr::vendor_crates(clean = TRUE)
  ```

- Keep `src/rust/vendor.tar.xz` and `src/rust/vendor-config.toml`; never
  commit the expanded `src/rust/vendor/` directory or Rust build
  targets.

- The R package and vendored zmij crate are MIT licensed. Keep
  `LICENSE.note`, `inst/COPYRIGHTS`, DESCRIPTION `Authors@R`, the
  vendored crate version, and retained upstream notices synchronized.
  David Tolnay authored the Rust port; Victor Zverovich authored the
  algorithm and original implementation. `LICENSE.note` must inventory
  every transitive crate in the vendor archive, including both vendored
  `syn` versions.

- Before handoff, run:

  ``` r

  devtools::document()
  devtools::test()
  devtools::check()
  ```

  The source package must compile from the offline vendor archive.
  Resolve package-caused errors, warnings, and notes; identify host-only
  findings separately. On macOS, Apple tooling may leave `xcrun_db` in
  the check temp directory; this is not produced by package code.

- Run `git diff --check` and remove local compiled artifacts before
  handoff. Do not commit or push unless the user explicitly asks.
