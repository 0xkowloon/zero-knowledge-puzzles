pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

template Min(n) {
  signal input in[n];
  signal output out;

  // no constraints here, just a computation
  // to find the min

  var min = in[0];
  for (var i = 1; i < n; i++) {
    min = in[i] < min ? in[i] : min;
  }

  signal minSignal;
  minSignal <-- min;

  // for each element in the array, assert that
  // min <= that element
  component LTE[n];
  component EQ[n];
  var acc = 0;
  for (var i = 0; i < n; i++) {
    LTE[i] = LessEqThan(252);
    LTE[i].in[0] <== minSignal;
    LTE[i].in[1] <== in[i];
    LTE[i].out === 1;

    // this is used in the
    // next code block to ensure
    // that minSignal equals at
    // least one of the inputs
    EQ[i] = IsEqual();
    EQ[i].in[0] <== minSignal;
    EQ[i].in[1] <== in[i];

    // acc is greater than zero
    // (acc != 0) if EQ[i].out
    // equals 1 at least one time
    acc += EQ[i].out;
  }

  // assert that minSignal is
  // equal to at least one of the
  // inputs. if acc = 0 then
  // none of the inputs equals
  // minSignal
  signal allZero;
  allZero <== IsEqual()([0, acc]);
  allZero === 0;
  out <== minSignal;
}

component main = Min(8);