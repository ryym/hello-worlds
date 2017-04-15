extern crate getopts;
extern crate rustc_serialize;
extern crate csv;

use getopts::Options;
use std::env;
use std::fs::File;
use std::path::Path;
use std::error::Error;

// This struct represents the data in each row of the CSV file.
#[derive(Debug, RustcDecodable)]
struct Row {
    country: String,
    city: String,
    accent_city: String,
    region: String,

    // Not every row has data for the population, latitude or longitude.
    population: Option<u64>,
    latitude: Option<f64>,
    longitude: Option<f64>,
}

struct PopulationCount {
    city: String,
    country: String,
    count: u64,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}",
             opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)))
}

fn search<P: AsRef<Path>>(file_path: P, city: &str) -> Result<Vec<PopulationCount>, Box<Error>> {
    let mut found = vec![];
    let file = try!(File::open(file_path));
    let mut rdr = csv::Reader::from_reader(file);

    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
            None => {} // Skip it.
            Some(count) => {
                if row.city == city {
                    found.push(PopulationCount {
                                   city: row.city,
                                   country: row.country,
                                   count: count,
                               });
                }
            }
        }
    }

    if found.is_empty() {
        Err(From::from("No matching cities with a population were found."))
    } else {
        Ok(found)
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = &args[0];

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(e) => panic!(e.to_string()),
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
        return;
    }

    let data_path = &matches.free[0]; // free: Vector<String>
    let city: &str = &matches.free[1];

    match search(data_path, city) {
        Ok(pops) => {
            for pop in pops {
                println!("{}, {}: {:?}", pop.city, pop.country, pop.count)
            }
        }
        Err(err) => println!("{}", err),
    }
}
