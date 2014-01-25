#!/usr/bin/env ruby

require_relative '../tubtim'
require 'stringio'

$out = STDOUT
$in = STDIN

$obs = StringIO.new

def gets
  $ibs.gets
end

def puts(*args)
  $obs.puts(*args)
end

class Sandbox

  def input=(input)
    $ib = input
    $ibs = StringIO.new($ib)
  end

  def eval_code(code)
    bind = get_binding
    parts = code.split(/(# =>)/)
    parts.length.times do |i|
      part = parts[i]
      if part == '# =>'
        parts[i] += " " + bind.eval(parts[i - 1]).inspect
      end
    end
    parts.join
  end

  private
  def get_binding
    binding
  end

end

readme = ARGF.read.lines.map { |x| x.match(/#[ ]?(.*)/) }.compact.map { |x| x[1] }.join "\n"
sandbox = Sandbox.new

readme.gsub!(/((Output|Input):\s*)?((?:^[ ]{4}.*\n)+)/) do
  preamble = $1
  is_input = $2 == 'Input'
  indented = $3
  code = indented.lines.map { |c| c[4..-1] }.join
  if is_input
    sandbox.input = code
    preamble + indented
  else
    code = sandbox.eval_code(code)
    "```ruby\n#{code}```\n"
  end
end

$out.puts readme.gsub('-->', '&rarr;')

