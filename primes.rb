
$prime = File.binread(File.join(File.dirname(__FILE__), 'sieve.txt'))

class Fixnum
  def prime?
    $prime[self] != '0'
  end
  def next_prime
    (self + 1).upto($prime.length - 1).find(&:prime?)
  end
  def prev_prime
    (self - 1).downto(2).find(&:prime?)
  end
end

