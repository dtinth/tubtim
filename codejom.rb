
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
  alias_method :cases, :cj
  def memoize(method_name)
    bang = (method_name.to_s + '!').to_sym
    memo = {}
    self.class.send :alias_method, bang, method_name
    self.class.send :define_method, method_name, Proc.new { |*args| memo[args] ||= self.send(bang, *args) }
  end
end

class Array
  def sum
    reduce(&:+)
  end
end

