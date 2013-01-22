This is my helper code for Thailand Code Jom.

Here is the relevant `.bash_profile`.

```bash
alias codejom_ruby='ruby -I ~/Codejom/_lib/ -r primes -r codejom'
alias ir='irb -I ~/Codejom/_lib/ -r primes -r codejom'
r() {
  codejom_ruby "$@" | tee ~/Codejom/out
}
```
