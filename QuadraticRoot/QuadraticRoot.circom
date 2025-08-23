pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/comparators.circom";

function sqrt(n) {
    if (n == 0) {
        return 0;
    }

    // Test that have solution
    var res = n ** ((-1) >> 1);
    // if (res!=1) assert(false, "SQRT does not exists");
    if (res!=1) return 0;

    var m = 28;
    var c = 19103219067921713944291392827692070036145651957329286315305642004821462161904;
    var t = n ** 81540058820840996586704275553141814055101440848469862132140264610111;
    var r = n ** ((81540058820840996586704275553141814055101440848469862132140264610111+1)>>1);
    var sq;
    var i;
    var b;
    var j;

    while ((r != 0)&&(t != 1)) {
        sq = t*t;
        i = 1;
        while (sq!=1) {
            i++;
            sq = sq*sq;
        }

        // b = c ^ m-i-1
        b = c;
        for (j=0; j< m-i-1; j ++) b = b*b;

        m = i;
        c = b*b;
        t = t*c;
        r = r*b;
    }

    if (r < 0 ) {
        r = -r;
    }

    return r;
}

template ModularSqrt() {
  signal input in;
  signal output out1; // sqrt(in)
  signal output out2; // -sqrt(in)

  out1 <-- sqrt(in);
  out2 <-- out1 * -1; // Computation Step (Unconstrained)
  out1 * out1 === in; // Verification Step (Constraint-Based):
  out2 * out2 === in; // Verification Step
}

template MulInv() {
  signal input in;
  signal output out;

  // compute
  out <-- 1 / in;

  // then constrain
  out * in === 1;
}

template QuadraticEquation() {
    signal input x;     // x value
    signal input a;     // coeffecient of x^2
    signal input b;     // coeffecient of x
    signal input c;     // constant c in equation
    signal input res;   // Expected result of the equation
    signal output out;  // If res is correct , then return 1 , else 0 .

    // your code here
    signal x_squared <== x * x;
    signal a_x_squared <== a * x_squared;
    signal b_x <== b * x;
    signal actual <== a_x_squared + b_x + c;

    component eq = IsEqual();
    eq.in[0] <== actual;
    eq.in[1] <== res;
    out <== eq.out;
}

template QuadraticRoot () {
    signal input coefficients[3];
    signal output roots[2];

    signal b_squared <== coefficients[1] * coefficients[1];
    signal four_ac <== 4 * coefficients[0] * coefficients[2];

    component mul_inv = MulInv();
    mul_inv.in <== 2 * coefficients[0];
    signal two_a_inv <== mul_inv.out;

    component modular_sqrt = ModularSqrt();
    signal discriminant <== b_squared - four_ac;
    modular_sqrt.in <== discriminant;

    signal sqrt_one <== modular_sqrt.out1;
    signal sqrt_two <== modular_sqrt.out2;

    signal neg_b <== -coefficients[1];
    roots[0] <== (neg_b + sqrt_one) * two_a_inv;
    roots[1] <== (neg_b + sqrt_two) * two_a_inv;

    component quadratic_equation_one = QuadraticEquation();
    quadratic_equation_one.x <== roots[0];
    quadratic_equation_one.a <== coefficients[0];
    quadratic_equation_one.b <== coefficients[1];
    quadratic_equation_one.c <== coefficients[2];
    quadratic_equation_one.res <== 0;

    component quadratic_equation_two = QuadraticEquation();
    quadratic_equation_two.x <== roots[1];
    quadratic_equation_two.a <== coefficients[0];
    quadratic_equation_two.b <== coefficients[1];
    quadratic_equation_two.c <== coefficients[2];
    quadratic_equation_two.res <== 0;

    quadratic_equation_one.out + quadratic_equation_two.out === 2;
}

component main = QuadraticRoot();