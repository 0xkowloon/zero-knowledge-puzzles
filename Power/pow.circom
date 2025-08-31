pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/multiplexer.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed.

template Pow(n) {
   signal input a[2];
   signal output c;

   if (n == 0) {
      c <== 1;
   } else if (n == 1) {
      c <== a[0];
   } else {
      signal powers[n + 1];

      powers[0] <== 1;
      powers[1] <== a[0];

      signal inLTn;
      inLTn <== LessThan(252)([a[1], n]);
      inLTn === 1;

      for (var i = 2; i < n; i++) {
         powers[i] <== powers[i - 1] * powers[1];
      }

      component mux = Multiplexer(1, n);
      mux.sel <== a[1];

      for (var i = 0; i < n; i++) {
         mux.inp[i][0] <== powers[i];
      }

      c <== mux.out[0];
   }

}

component main = Pow(5);

