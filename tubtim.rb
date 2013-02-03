
require 'backports/2.0'
require 'mathn'
require 'primes'

class Integer
  def array(&block)
    Array.new(self, &block)
  end
  def factorize
    x = self
    o = []
    loop do
      break unless (c = (2..x).find { |i| x % i == 0 })
      x /= c
      o << c
    end
    o
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

class NilClass
  def get_next_prime
    nil
  end
  def get_prev_prime
    nil
  end
end

class Fixnum
  def next_prime(n=1)
    apply(n, &:get_next_prime)
  end
  def prev_prime(n=1)
    apply(n, &:get_prev_prime)
  end
  def th_prime
    1.next_prime(self)
  end
  alias_method :st_prime, :th_prime
  alias_method :nd_prime, :th_prime
  alias_method :rd_prime, :th_prime
end

class Array
  def bsearch(value)
    index = lbound(value)
    self[index] == value ? index : nil
  end
  def lbound(value)
    min = 0
    max = length
    left = min
    right = max
    while left <= right
      mid = ((left + right) / 2).to_i
      if self[mid] <= value
        if mid + 1 >= max || value < self[mid + 1]
          return mid
        else
          left = mid + 1
        end
      else
        right = mid - 1
      end
    end
    return 0
  end
end
