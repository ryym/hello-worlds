
ar1 = (1...100).to_a

ar2 = ar1.map {|i| i * 100}

# puts ar2

ar3 = ar1.select {|i| i % 3 == 0}

# puts ar3
# puts ar1.reject! {|i| i % 3 == 0}


def left?(prn)
  prn == "(" || prn == "{"
end

def pair?(l,r)
  (l == "(" && r == ")") || (l == "{" && r == "}")
end


def balanced?(prns)
  unclosed = []
  for p in prns
    if left? p
      unclosed.push p
    elsif unclosed.size > 0
      if pair? unclosed.last, p
        unclosed.pop
      else
        return false
      end
    else
      return false
    end
  end
  unclosed.empty?
end

# puts %w<( ( {} ) )>
puts balanced?(%w<( ( { } ) )>)
