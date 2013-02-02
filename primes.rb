
$prime = File.binread(File.join(File.dirname(__FILE__), 'sieve.txt'))

class Fixnum
  def prime?
    $prime[self] != '0'
  end
  def get_next_prime
    (self + 1).upto($prime.length - 1).find(&:prime?)
  end
  def get_prev_prime
    (self - 1).downto(2).find(&:prime?)
  end
end

