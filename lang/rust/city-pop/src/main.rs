extern crate getopts;
extern crate rustc_serialize;
extern crate csv;
extern crate city_pop;

use getopts::Options;
use std::env;
use std::process;
use city_pop::errors::CliError;
use city_pop::search::search;

fn print_usage(program: &str, opts: Options) {
    println!("{}",
             opts.usage(&format!("Usage: {} [options] <city>", program)))
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optopt("f",
                "file",
                "choose an input file, instead of using STDIN.",
                "NAME");
    opts.optflag("h", "help", "Show this usage message.");
    opts.optflag("q", "quiet", "Silences errors and warnings.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(e) => panic!(e.to_string()),
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let data_path = matches.opt_str("f");

    let city = if !matches.free.is_empty() {
        &matches.free[0]
    } else {
        print_usage(&program, opts);
        return;
    };

    match search(&data_path, city) {
        Ok(pops) => {
            for pop in pops {
                println!("{}, {}: {:?}", pop.city, pop.country, pop.count)
            }
        }
        Err(CliError::NotFound) if matches.opt_present("q") => process::exit(1),
        Err(err) => println!("{}", err),
    }
}
