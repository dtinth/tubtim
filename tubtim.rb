
require 'primes'

class Integer
  def array(&block)
    Array.new(self, &block)
  end
end

class Applier
  include Enumerable
  def initialize(start, &block)
    @block = block
    @value = start
  end
  def each
    loop do
      @value = @block.call(@value)
      yield @value
    end
  end
end

class Object
  def self
    self
  end
  def apply(times=nil)
    c = self
    if times.nil?
      Applier.new(c) { |x| yield x }
    else
      times.times do c = yield c end
      c
    end
  end
end

module Kernel
  private
  def strs
    gets.split
  end
  def ints
    strs.map(&:to_i)
  end
  def yesno(s)
    puts s ? 'yes' : 'no'
  end
  def cj(&block)
    gets.to_i.times(&block)
  end
  alias_method :cases, :cj
  def memoize(method_name)
    bang = (method_name.to_s + '!').to_sym
    memo = {}
    self.class.send :alias_method, bang, method_name
    self.class.send :define_method, method_name, Proc.new { |*args| memo[args] ||= self.send(bang, *args) }
  end
end

module Enumerable
  def sum
    reduce(&:+)
  end
  def stat
    each_with_object(Hash.new(0)) { |c, o| o[c] += 1 }
  end
end

class Fixnum
  def next_prime(n=1)
    apply(n, &:get_next_prime)
  end
  def prev_prime(n=1)
    apply(n, &:get_prev_prime)
  end
end

