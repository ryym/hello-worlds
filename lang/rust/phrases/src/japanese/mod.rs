// Export each function from this scope.
pub use self::greetings::hello;
pub use self::farewells::goodbye;

// Keep modules private.
mod greetings;
mod farewells;
