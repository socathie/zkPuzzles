pragma circom 2.0.3;

include "../node_modules/circomlib-matrix/circuits/matAdd.circom";
include "../node_modules/circomlib-matrix/circuits/matElemMul.circom";
include "../node_modules/circomlib-matrix/circuits/matElemSum.circom";
include "../node_modules/circomlib-matrix/circuits/matElemPow.circom";
include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;

    component lt = LessEqThan(n);
    component gt = GreaterEqThan(n);

    lt.in[0] <== in;
    lt.in[1] <== range[1];

    gt.in[0] <== in;
    gt.in[1] <== range[0];

    out <== lt.out * gt.out;
}

template Multiplier9() {
    signal input in[9];
    signal output out;

    signal tmp[9];

    tmp[0] <== in[0];

    for (var i=1; i<9; i++) {
        tmp[i] <== tmp[i-1]*in[i];
    }

    out <== tmp[8];
}