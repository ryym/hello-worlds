
filename = ARGV[0]
file = open filename
while text = file.gets do
  print text
  puts "!"
end
file.close
