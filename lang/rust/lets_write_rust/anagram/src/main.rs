use std::collections::HashMap;
use std::fs::File;
use std::io;
use std::io::BufRead;
use std::path::Path;

fn sorted_string(s: &str) -> String {
    // s: Vec<char> 推論可能なので _ で省略している。
    let mut s = s.chars().collect::<Vec<_>>();
    s.sort();
    s.into_iter().collect::<String>()
}

struct Anagram(HashMap<String, Vec<String>>);

impl Anagram {
    fn new<P: AsRef<Path>>(dictfile: P) -> Result<Self, io::Error> {
        let file = File::open(dictfile)?;
        let file = io::BufReader::new(file);

        let mut anagram = Anagram(HashMap::new());
        for line in file.lines() {
            let word = line?;
            anagram.add_word(word);
        }
        Ok(anagram)
    }

    // `word`の所有権を奪う。
    fn add_word(&mut self, word: String) {
        let sorted = sorted_string(&word);

        // entry(sorted) -> Entry<String, Vec<String>>
        // Entry::or_insert -> Vec<String>
        // Vec::push
        self.0.entry(sorted).or_insert(Vec::new()).push(word);
    }

    // 参照するだけなので所有権はもらわず借用する。
    fn find(&self, word: &str) -> Option<&Vec<String>> {
        let word = sorted_string(word);
        self.0.get(&word)
    }
}

fn main() {
    let word = std::env::args().nth(1).expect("USAGE: word");
    let table = Anagram::new("/usr/share/dict/words").expect("failed to make table");
    println!("{:?}", table.find(&word));
}
