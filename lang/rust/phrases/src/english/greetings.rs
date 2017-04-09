pub fn hello() -> String {
    internal_hello()
}

// This function can't be called from the outside.
fn internal_hello() -> String {
    "Hello".to_string()
}
