# テキストファイルの行数、単語数、文字数を数える

nLines = 0
nWords = 0
nChars = 0
open("l_w_c.txt") {|io|
  while line = io.gets
    nLines += 1
    nWords += line.split(/\s+/).reject{|w| w.empty?}.size 
    nChars += line.sub(/\n/, "").length
  end
}

puts nLines, nWords, nChars
