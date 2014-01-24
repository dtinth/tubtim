
require 'mathn'

class Fixnum
  def get_next_prime
    c = self
    loop do
      c += 1
      return c if c.prime?
    end
  end
  def get_prev_prime
    (self - 1).downto(2).find(&:prime?)
  end
end

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
  def bound(length)
    0 <= self && self < length
  end
end

class Object
  def self
    self
  end
  def apply(times=nil)
    c = self
    if times.nil?
      Enumerator.new do |y|
        loop do
          y << (c = yield c)
        end
      end
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

  def eat(how_many=nil)
    (how_many || gets.to_i).array { gets.strip }
  end

  def yesno(s)
    puts s ? 'yes' : 'no'
  end

  def cases(&block)
    gets.to_i.times(&block)
  end

  def memoize(a=nil, &b)
    block = a || b
    memo = { }
    call = -> *args { memo[args] ||= block[call, *args] }
  end

  def trampoline(a=nil, &b)
    block = a || b
    jump = -> x { x = x[] while Proc === x; x }
    make = -> *args { -> { block[make, *args] } }
    -> *args { jump[make[*args]] }
  end

end

module Enumerable
  def sum
    reduce(&:+)
  end
  def stat
    each_with_object(Hash.new(0)) { |c, o| o[c] += 1 }
  end
  def compact
    reject(&:nil?)
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
  def lower_bound(&block)
    (0...length).bsearch { |c| yield self[c] } || length
  end
end













