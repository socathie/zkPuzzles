const chai = require("chai");

const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

describe("Sudoku circuit test", function () {
  this.timeout(100000000);

  it("Should fail for invalid solution", async () => {
    const circuit = await wasm_tester("circuits/sudoku.circom");
    await circuit.loadConstraints();
    assert.equal(circuit.nVars, 4372);
    assert.equal(circuit.constraints.length, 4332);

    const INPUT = {
      "puzzle": [
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "0"]
      ],
      "solution": [
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"],
        ["5", "5", "5", "5", "5", "5", "5", "5", "5"]
      ]
    }

    const witness = await circuit.calculateWitness(INPUT, true)
      .catch((error) => {
        errorString = error.toString();
      });

    //console.log(errorString);

    assert(errorString=="Error: Error: Assert Failed. Error in template sudoku_79 line: 91");
  });

  it("Should compute correct solution", async () => {
    const circuit = await wasm_tester("circuits/sudoku.circom");
    await circuit.loadConstraints();
    assert.equal(circuit.nVars, 4372);
    assert.equal(circuit.constraints.length, 4332);

    const INPUT = {
      "puzzle": [
        ["1", "0", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "8", "0", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "6", "0", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "5", "0", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "3", "0", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "1", "0", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "9", "0", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "7", "0"],
        ["0", "0", "0", "0", "0", "0", "0", "0", "5"]
      ],
      "solution": [
        ["0", "7", "4", "2", "8", "5", "3", "9", "6"],
        ["2", "0", "5", "3", "9", "6", "4", "1", "7"],
        ["3", "9", "0", "4", "1", "7", "5", "2", "8"],
        ["4", "1", "7", "0", "2", "8", "6", "3", "9"],
        ["5", "2", "8", "6", "0", "9", "7", "4", "1"],
        ["6", "3", "9", "7", "4", "0", "8", "5", "2"],
        ["7", "4", "1", "8", "5", "2", "0", "6", "3"],
        ["8", "5", "2", "9", "6", "3", "1", "0", "4"],
        ["9", "6", "3", "1", "7", "4", "2", "8", "0"]
      ]
    }

    const witness = await circuit.calculateWitness(INPUT, true)

    //console.log(witness);

    assert(Fr.eq(Fr.e(witness[0]),Fr.e(1)));
    assert(Fr.eq(Fr.e(witness[1]),Fr.e('14859242797732307376594647282705218440328040987055989295014298721628438034438')));
  });
});