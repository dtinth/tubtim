
require 'mathn'

# Tubtim — helper library for speed coding
# ===
#
# This library contains utility methods to make it faster to write code
# in speed-coding competitions, such as [Thailand Code Jom](http://codejom.thailandoi.org/).
#
# Upon importing this library, `mathn` will be require'd too.
# Diving integer with an integer will result in a Rational.
# `matrix` and `prime` is also imported.
#

# API: Global Functions
# ---------------------
#
module Kernel

  private

  #### strs --> ary
  #
  # Reads a line of text from standard input and split by whitespace.
  #
  # Input:
  #
  #     hello world, this is a test
  #
  # Example:
  # 
  #     strs  # =>
  #
  def strs
    gets.split
  end

  #### ints --> ary
  #
  # Read several integers from standard input, separated by whitespace.
  # Equivalent to `strs.map(&:to_i)`
  #
  # Input:
  #
  #     3 1 4 1 59265 3 5 8 9
  #
  # Example:
  #
  #     ints  # =>
  #
  def ints
    strs.map(&:to_i)
  end

  #### eat(n) --> ary
  #
  # Read `n` lines from standard input and return as array.
  #
  # Input:
  #
  #     hello
  #     world
  #     test
  #
  # Example:
  #
  #     eat(2)   # =>
  #     eat(1)   # =>
  #
  #### eat --> ary
  #
  # Reads a number `n` and then reads `n` lines and put them in an array.
  #
  # Input:
  # 
  #     3
  #     hello
  #     world
  #     test
  #     cool
  #
  # Example:
  #
  #     eat  # =>
  #
  def eat(how_many=nil)
    (how_many || gets.to_i).array { gets.strip }
  end

  #### yesno(bool) --> nil
  #
  # Prints `yes` if true is given, `no` otherwise.
  #
  # Example:
  #
  #     yesno 5 == 8
  #     yesno 7 == 9
  #
  def yesno(s)
    puts s ? 'yes' : 'no'
  end

  #### cases { |index| block }
  #
  # Reads in a number `n`, then runs the specified block `n` times.
  #
  # Input:
  #
  #     2
  #     1 2 3
  #     4 5 6
  #
  # Example:
  #
  #     cases do
  #       p ints
  #     end
  #     
  def cases(&block)
    gets.to_i.times(&block)
  end

  #### memoize { |recurse, *args| block } --> proc --> any<br>memoize(proc) --> proc --> any
  #
  # Create a proc which memoizes a given block/proc.
  #
  #     memoize(-> f, x { x < 2 ? x : f[x - 1] + f[x - 2] })[50] # =>
  #       # (this is a the fibonacci function)
  #
  def memoize(a=nil, &b)
    block = a || b
    memo = { }
    call = -> *args { memo[args] ||= block[call, *args] }
  end

  #### trampoline { |recurse, *args| block } --> proc --> any<br>trampoline(proc) --> proc --> any
  #
  # Performs trampoline on a block/proc.
  # As long as it returns a block/proc, it will be invoked.
  # 
  #     f = trampoline -> f, a, b { a == 0 ? b : -> { f[a - 1, b + 1] } }
  #     f[100000,50000] # =>
  #       # (f[a, b] returns the sum of a + b, given a and b are positive)
  #
  def trampoline(a=nil, &b)
    block = a || b
    jump = -> x { x = x[] while Proc === x; x }
    make = -> *args { -> { block[make, *args] } }
    -> *args { jump[make[*args]] }
  end

end

# API: Object
# -----------
# These methods may be called on any object.
#
class Object

  #### self --> self
  #
  # The identity method—just returns self
  #
  #     :wtf.self  # =>
  #
  def self
    self
  end

  #### apply(times) { |obj| block } --> obj
  #
  # Applys the block `times` times.
  #
  #     1.apply(3) { |x| x * 2 + 1 }   # =>
  #       # (1 --> 3 --> 7 --> 15)
  #     100000.apply(10, &:prev_prime) # =>
  #
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

# API: Integer
# ------------
#
class Integer

  #### array { |index| block } --> ary
  #
  # Equivalent to `Array.new(n) { |index| block }`
  #
  #     5.array { |x| x ** 2 } # =>
  #
  def array(&block)
    Array.new(self, &block)
  end

  #### factorize --> ary
  #
  # Performs prime factorization.
  #
  #     480.factorize # =>
  #
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

  #### bound(length) --> bool
  #
  # Returns true if 0 <= self < length
  #
  #     -1.bound(10)   # =>
  #     0.bound(10)    # =>
  #     9.bound(10)    # =>
  #
  def bound(length)
    0 <= self && self < length
  end
end


# API: Enumerable
# ---------------
#
module Enumerable

  #### sum --> any
  #
  # Equivalent to `reduce(&:+)`.
  #
  #     (1..100).sum  # =>
  def sum
    reduce(&:+)
  end

  #### stat --> hash
  #
  # Returns a hash containing the frequency of values in this enumerable.
  #
  #     [3,1,4,1,5,9,2,6,5,3,5,8,9].stat
  #       # =>
  #
  def stat
    each_with_object(Hash.new(0)) { |c, o| o[c] += 1 }
  end

  #### compact --> array
  #
  # Rejects `nil`. Equivalent to `reject(&:nil?)`.
  #
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

# API: Fixnum
# -----------
#
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

  #### next_prime(n=1) --> fixnum
  #
  # Returns the nth next prime.
  #
  #     1024.next_prime      # =>
  #     1024.next_prime(10)  # =>
  #
  def next_prime(n=1)
    apply(n, &:get_next_prime)
  end

  #### prev_prime(n=1) --> fixnum
  #
  # Returns the nth previous prime.
  #
  #     1024.prev_prime      # =>
  #     1024.prev_prime(10)  # =>
  #
  def prev_prime(n=1)
    apply(n, &:get_prev_prime)
  end

  #### th_prime --> fixnum<br>st_prime --> fixnum<br>nd_prime --> fixnum<br>rd_prime --> fixnum
  #
  # Returns the (self)th time.
  #
  #     21.st_prime    # =>
  #     42.nd_prime    # =>
  #     1023.th_prime  # =>
  #     7.th_prime     # =>
  #
  def th_prime
    1.next_prime(self)
  end
  alias_method :st_prime, :th_prime
  alias_method :nd_prime, :th_prime
  alias_method :rd_prime, :th_prime

end

# API: Array
# ----------
#
class Array

  #### lower_bound { |elem| block } --> int
  #
  # Like `bsearch`, but returns the index.
  #
  # Additionally, if the index is not in the array,
  # returns the array length.
  #
  # For example,
  #
  #     a = [3, 5, 9, 20, 21]
  #     a.lower_bound { |x| x >= 0 }   # =>
  #     a.lower_bound { |x| x >= 2 }   # =>
  #     a.lower_bound { |x| x >= 3 }   # =>
  #     a.lower_bound { |x| x >= 4 }   # =>
  #     a.lower_bound { |x| x >= 5 }   # =>
  #     a.lower_bound { |x| x >= 18 }  # =>
  #     a.lower_bound { |x| x >= 20 }  # =>
  #     a.lower_bound { |x| x >= 21 }  # =>
  #     a.lower_bound { |x| x >= 40 }  # =>
  #
  def lower_bound(&block)
    (0...length).bsearch { |c| yield self[c] } || length
  end

end













