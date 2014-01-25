Tubtim — helper library for speed coding
===

This library contains utility methods to make it faster to write code
in speed-coding competitions, such as [Thailand Code Jom](http://codejom.thailandoi.org/).

Upon importing this library, `mathn` will be require'd too.
Diving integer with an integer will result in a Rational.
`matrix` and `prime` is also imported.

API: Global Functions
---------------------

### strs &rarr; ary

Reads a line of text from standard input and split by whitespace.

Input:

    hello world, this is a test

Example:

```ruby
strs  # => ["hello", "world,", "this", "is", "a", "test"]
```

### ints &rarr; ary

Read several integers from standard input, separated by whitespace.
Equivalent to `strs.map(&:to_i)`

Input:

    3 1 4 1 59265 3 5 8 9

Example:

```ruby
ints  # => [3, 1, 4, 1, 59265, 3, 5, 8, 9]
```

### eat(n) &rarr; ary

Read `n` lines from standard input and return as array.

Input:

    hello
    world
    test

Example:

```ruby
eat(2)   # => ["hello", "world"]
eat(1)   # => ["test"]
```

### eat &rarr; ary

Reads a number `n` and then reads `n` lines and put them in an array.

Input:

    3
    hello
    world
    test
    cool

Example:

```ruby
eat  # => ["hello", "world", "test"]
```

### yesno(bool) &rarr; nil

Prints `yes` if true is given, `no` otherwise.

Example:

```ruby
yesno 5 == 8
yesno 7 == 9
```

### cases { |index| block }

Reads in a number `n`, then runs the specified block `n` times.

Input:

    2
    1 2 3
    4 5 6

Example:

```ruby
cases do
  p ints
end

```
### memoize { |recurse, *args| block } &rarr; proc &rarr; any<br>memoize(proc) &rarr; proc &rarr; any

Create a proc which memoizes a given block/proc.

```ruby
memoize(-> f, x { x < 2 ? x : f[x - 1] + f[x - 2] })[50] # => 12586269025
  # (this is a the fibonacci function)
```

### trampoline { |recurse, *args| block } &rarr; proc &rarr; any<br>trampoline(proc) &rarr; proc &rarr; any

Performs trampoline on a block/proc.
As long as it returns a block/proc, it will be invoked.

```ruby
f = trampoline -> f, a, b { a == 0 ? b : -> { f[a - 1, b + 1] } }
f[100000,50000] # => 150000
  # (f[a, b] returns the sum of a + b, given a and b are positive)
```

API: Object
-----------
These methods may be called on any object.

### self &rarr; self

The identity method—just returns self

```ruby
:wtf.self  # => :wtf
```

### apply(times) { |obj| block } &rarr; obj

Applys the block `times` times.

```ruby
1.apply(3) { |x| x * 2 + 1 }   # => 15
  # (1 &rarr; 3 &rarr; 7 &rarr; 15)
100000.apply(10, &:prev_prime) # => 99877
```

API: Integer
------------

### array { |index| block } &rarr; ary

Equivalent to `Array.new(n) { |index| block }`

```ruby
5.array { |x| x ** 2 } # => [0, 1, 4, 9, 16]
```

### factorize &rarr; ary

Performs prime factorization.

```ruby
480.factorize # => [2, 2, 2, 2, 2, 3, 5]
```

### bound(length) &rarr; bool

Returns true if 0 <= self < length

```ruby
-1.bound(10)   # => false
0.bound(10)    # => true
9.bound(10)    # => true
```

API: Enumerable
---------------

### sum &rarr; any

Equivalent to `reduce(&:+)`.

```ruby
(1..100).sum  # => 5050
```
### stat &rarr; hash

Returns a hash containing the frequency of values in this enumerable.

```ruby
[3,1,4,1,5,9,2,6,5,3,5,8,9].stat
  # => {3=>2, 1=>2, 4=>1, 5=>3, 9=>2, 2=>1, 6=>1, 8=>1}
```

### compact &rarr; array

Rejects `nil`. Equivalent to `reject(&:nil?)`.

API: Fixnum
-----------

### next_prime(n=1) &rarr; fixnum

Returns the nth next prime.

```ruby
1024.next_prime      # => 1031
1024.next_prime(10)  # => 1091
```

### prev_prime(n=1) &rarr; fixnum

Returns the nth previous prime.

```ruby
1024.prev_prime      # => 1021
1024.prev_prime(10)  # => 967
```

### th_prime &rarr; fixnum<br>st_prime &rarr; fixnum<br>nd_prime &rarr; fixnum<br>rd_prime &rarr; fixnum

Returns the (self)th time.

```ruby
21.st_prime    # => 73
42.nd_prime    # => 181
1023.th_prime  # => 8147
7.th_prime     # => 17
```

API: Array
----------

### lower_bound { |elem| block } &rarr; int

Like `bsearch`, but returns the index.

Additionally, if the index is not in the array,
returns the array length.

For example,

```ruby
a = [3, 5, 9, 20, 21]
a.lower_bound { |x| x >= 0 }   # => 0
a.lower_bound { |x| x >= 2 }   # => 0
a.lower_bound { |x| x >= 3 }   # => 0
a.lower_bound { |x| x >= 4 }   # => 1
a.lower_bound { |x| x >= 5 }   # => 1
a.lower_bound { |x| x >= 18 }  # => 3
a.lower_bound { |x| x >= 20 }  # => 3
a.lower_bound { |x| x >= 21 }  # => 4
a.lower_bound { |x| x >= 40 }  # => 5
```
