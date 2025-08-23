pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that constrains the 4 input signals to be
// sorted. Sorted means the values are non decreasing starting
// at index 0. The circuit should not have an output.

template IsSorted() {
    signal input in[4];
    signal leq1;
    signal leq2;
    signal leq3;

    // one line assignment to the signal
    leq1 <== LessEqThan(252)([in[0], in[1]]);
    leq2 <== LessEqThan(252)([in[1], in[2]]);
    leq3 <== LessEqThan(252)([in[2], in[3]]);

    leq1 === 1;
    leq2 === 1;
    leq3 === 1;
}

component main = IsSorted();
