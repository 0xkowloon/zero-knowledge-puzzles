const chai = require('chai');
const { wasm } = require('circom_tester');
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const wasm_tester = require("circom_tester").wasm;

const assert = chai.assert;

describe("Min Test ", function (){
    this.timeout(100000);

    it("Check Not Equal", async()=>{
        const circuit = await wasm_tester(path.join(__dirname,"../Min","Min.circom"));
        await circuit.loadConstraints();
        let witness ;

        witness = await circuit.calculateWitness({"in":[1,2,3,4,5,6,7,8]},true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(1)));

        witness = await circuit.calculateWitness({"in":[2,2,2,2,2,2,2,2]},true);
        assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]), Fr.e(2)));
    })
})