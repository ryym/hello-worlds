use std::fs::File;
use std::path::Path;
use std::io;
use csv;
use errors::CliError;

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

pub struct PopulationCount {
    pub city: String,
    pub country: String,
    pub count: u64,
}

pub fn search<P: AsRef<Path>>(file_path: &Option<P>,
                              city: &str)
                              -> Result<Vec<PopulationCount>, CliError> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);

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
        Err(CliError::NotFound)
    } else {
        Ok(found)
    }
}
