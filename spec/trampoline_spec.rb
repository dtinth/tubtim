
describe 'trampoline' do
  
  it 'should perform trampolining' do

    sum1 = trampoline do |f, a, b|
      a > 0 ? -> { f[a - 1, b + a] } : b
    end

    sum2 = trampoline -> f, a, b {
      a > 0 ? -> { f[a - 1, b + a] } : b
    }

    expect(sum1[32768, 0]).to eq((1..32768).reduce(&:+))
    expect(sum2[32768, 0]).to eq((1..32768).reduce(&:+))

  end

end

describe 'memoize' do
  
  it 'should memoize value' do
    
    fib1 = memoize { |f, x| x > 1 ? f[x - 1] + f[x - 2] : x }

    fib2 = memoize -> f, x { x > 1 ? f[x - 1] + f[x - 2] : x }

    fib_iterative = -> x {
      a = 0
      b = 1
      x.times { a, b = [b, a + b] }
      a
    }

    expect(fib1[1000]).to eq(fib_iterative[1000])
    expect(fib2[1000]).to eq(fib_iterative[1000])

  end

end
