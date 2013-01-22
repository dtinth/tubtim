
def gen_sieve
  max = 50000000
  sieve = ""
  max.times { sieve << "1" }
  sieve[0] = '0'
  sieve[1] = '0'
  i = 2
  while i * 2 < max
    if sieve[i] == '1'
      puts i
      j = i + i
      while j < max
        sieve[j] = '0'
        j += i
      end
    end
    i += 1
  end
  File.open 'sieve.txt', 'wb' do |io|
    io << sieve
  end
end

gen_sieve
