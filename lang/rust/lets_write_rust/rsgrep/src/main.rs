extern crate regex;
use regex::Regex;

use std::fs::File;
use std::io::{BufReader, BufRead};
use std::env;

fn usage() {
    println!("rsgrep PATTERN FILENAME")
}

fn main() {
    let pattern = match env::args().nth(1) {
        Some(pattern) => pattern,
        None => {
            usage();
            return;
        }
    };

    // `new`もただの関連関数だから、Optionなど任意の値を返せる。
    let reg = match Regex::new(&pattern) {
        Ok(reg) => reg,
        Err(e) => {
            println!("Err {}: {}", pattern, e);
            return;
        }
    };

    let filename = match env::args().nth(2) {
        Some(filename) => filename,
        None => {
            usage();
            return;
        }
    };

    let file = match File::open(&filename) {
        Ok(file) => file,
        Err(e) => {
            println!("Err {}: {}", filename, e);
            return;
        }
    };

    let input = BufReader::new(file);
    for line in input.lines() {
        let line = match line {
            Ok(line) => line,
            Err(e) => {
                println!("Err {}", e);
                return;
            }
        };

        if reg.is_match(&line) {
            println!("{}", line);
        }
    }
}
