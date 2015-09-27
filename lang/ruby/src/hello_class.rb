#!usr/bin/ruby
# coding: utf-8

# hello, class

class HelloWorld
  # Generate accessor method for the 'name' field.
  attr_accessor :name

  # 'new' method
  def initialize(myname = "Ruby")
    @name = myname
  end

  # instance method
  def hello
    print "Hello, world. I am ", @name, " \n"
  end

  # class method
  def self.greet
    print "Good morning!\n"
  end
end

bob   = HelloWorld.new "Bob"
alice = HelloWorld.new "Alice"
ruby  = HelloWorld.new

bob.hello
alice.hello
ruby.hello

ruby.name = "Perl"
ruby.hello
print "now, the instance [ruby]'s name is ", ruby.name, " \n"
r
# ruby.greet : error
HelloWorld.greet

# redefine class
class HelloWorld
  def bye
    puts "Good bye!"
  end
end

bob.bye
