use extendr_api::prelude::*;

/// Format doubles with zmij.
///
/// @noRd
#[extendr]
fn format_double_impl(x: Doubles) -> Strings {
    let mut output = Strings::new_with_na(x.len());
    let mut buffer = zmij_rs::Buffer::new();

    for (i, value) in x.iter().enumerate() {
        if !value.is_na() {
            output.set_elt(i, Rstr::from(buffer.format(value.0)));
        }
    }

    output
}

/// Parse doubles with Rust's correctly rounded parser.
///
/// @noRd
#[extendr]
fn parse_double_impl(x: Strings) -> extendr_api::Result<Doubles> {
    if x.is_empty() {
        let output: Robj = Vec::<f64>::new().into();
        return output.try_into();
    }

    let mut output = Doubles::new_with_na(x.len());

    for (i, value) in x.iter().enumerate() {
        if !value.is_na() {
            let parsed = value.as_ref().parse::<f64>().map_err(|_| {
                Error::Other(format!(
                    "`x[[{}]]` is not a valid floating-point string.",
                    i + 1
                ))
            })?;
            output.set_elt(i, Rfloat::from(parsed));
        }
    }

    Ok(output)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod zmij;
    fn format_double_impl;
    fn parse_double_impl;
}
