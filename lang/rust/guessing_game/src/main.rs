use std::io;

fn main() {
    println!("Guess the number!");

    println!("Please input your guess.");

    // Make it mutable.
    let mut guess = String::new();

    // Read a line with error handling.
    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
