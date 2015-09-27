
def cels2fahr(cels)
  return Float(cels) * 9 / 5 + 32
end

def fahr2cels(fahr)
  (Float(cels) - 32) * 5 / 9
end

# def.upto(100) {|i|
#   print "cels: ", i, " fahr: ", cels2fahr(i), "\n"
# }

def dice()
  rand(6) + 1
end

print dice, dice, "\n"

# Return true if num is a prime number.
def prime?(num)
  return false if num < 2
  2.upto(Math.sqrt(num)) {|i|
    return false if num % i == 0
  }
  return true
end

puts prime?(1)
puts prime?(7)
puts prime?(10)
