
This repository contains a collection of utility methods for Ruby.
Such as array summing and statistics, prime numbers, and shorthand methods.

This library is created for use in Thailand Code Jom 2013,
a programming competition focused on speed, so that with this I can write code
to solve problem faster than using just standard APIs provided by Ruby.

Here is the relevant `.bash_profile`.

```bash
alias codejom_ruby='ruby -I ~/Codejom/_lib/ -r tubtim'
alias ir='irb -I ~/Codejom/_lib/ -r tubtim'
r() {
  codejom_ruby "$@" | tee ~/Codejom/out
}
i() {
  cat > input
}
```
