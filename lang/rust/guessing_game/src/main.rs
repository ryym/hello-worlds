extern crate rand;

use std::io;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    // 'use rand::Rng' (trait) makes gen_range method available.
    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("secret number: {}", secret_number);

    println!("Please input your guess.");

    // Make it mutable.
    let mut guess = String::new();

    // Read a line with error handling.
    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
