// executable crate

extern crate phrases;

use phrases::english::{greetings, farewells};
use phrases::japanese;

// we can `use` a function directly.
// use phrases::english::greetings::hello;

// we can rename the imported things by `as`.
// use phrases::japanese::hello as ja_hello;

fn main() {
    println!("Hello in English: {}", greetings::hello());
    println!("Goodbye in English: {}", farewells::goodbye());

    println!("Hello in Japanese: {}", japanese::hello());
    println!("Goodbye in Japanese: {}", japanese::goodbye());
}
