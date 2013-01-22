
class Integer
  def array(&block)
    Array.new(self, &block)
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
end

class Array
  def sum
    reduce(&:+)
  end
end

