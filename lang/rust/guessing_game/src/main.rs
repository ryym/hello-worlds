extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    // 'use rand::Rng' (trait) makes gen_range method available.
    let secret_number = rand::thread_rng().gen_range(1, 101);

    loop {
        println!("Please input your guess.");

        // Make it mutable.
        let mut guess = String::new();

        // Read a line with error handling.
        io::stdin().read_line(&mut guess)
            .expect("Failed to read line");

        // 入力を数値型に変換した値をguessに再代入する。
        // このletにはmutをつけていないから、これ以降はguessに再代入できない。
        // 普通同じ変数への再代入はアンチパターンだが、型指定ができてかつ
        // 以降の再代入可否をコントロールできるなら確かに`guess_int`とか書くより
        // 良さそう。
        // なお型指定をしなくていいなら、let無しでも数値を再代入できる。
        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Please input a number!");
                continue;
            },
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            },
        }
    }
}
