const chai = require("chai");
const { wasm } = require("circom_tester");
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString(
  "21888242871839275222246405745257275088548364400416034343698204186575808495617",
);
const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("Quadratic Roots Test ", function () {
  this.timeout(100000);

  it("Should create a Quadratic circuit verifier successfully", async () => {
    const circuit = await wasm_tester(
      path.join(__dirname, "../QuadraticRoot", "QuadraticRoot.circom"),
    );
    await circuit.loadConstraints();
    let witness;

    const expectedOutput = [
      "2",
      "1"
    ];

    witness = await circuit.calculateWitness(
      {
        "coefficients": ["1", "-3", "2"]
      },
      true,
    );

    assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
    assert(Fr.eq(Fr.e(witness[1]), Fr.e(expectedOutput[0])));
    assert(Fr.eq(Fr.e(witness[2]), Fr.e(expectedOutput[1])));
  });
});