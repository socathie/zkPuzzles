pragma circom 2.0.3;

include "./util.circom";

template sudoku() {
    signal input puzzle[9][9]; // 0  where blank
    signal input solution[9][9]; // 0 where original puzzle is not blank
    signal output out;

    // check whether the solution is zero everywhere the puzzle has values (to avoid trick solution)

    component mul = matElemMul(9,9);
    
    for (var i=0; i<9; i++) {
        for (var j=0; j<9; j++) {

            //assert(puzzle[i][j]>=0);
            //assert(puzzle[i][j]<=9);
            //assert(solution[i][j]>=0);
            //assert(solution[i][j]<=9);
            mul.a[i][j] <== puzzle[i][j];
            mul.b[i][j] <== solution[i][j];
        }
    }
    for (var i=0; i<9; i++) {
        for (var j=0; j<9; j++) {
            mul.out[i][j] === 0;
        }
    }

    // sum up the two inputs to get full solution and square the full solution

    component add = matAdd(9,9);
    
    for (var i=0; i<9; i++) {
        for (var j=0; j<9; j++) {
            add.a[i][j] <== puzzle[i][j];
            add.b[i][j] <== solution[i][j];
        }
    }

    component square = matElemPow(9,9,2);

    // check the full solution only has 1 to 9
    component rangeProof[9][9];

    for (var i=0; i<9; i++) {
        for (var j=0; j<9; j++) {
            square.a[i][j] <== add.out[i][j];

            rangeProof[i][j] = RangeProof(4);

            rangeProof[i][j].range[0] <== 1;
            rangeProof[i][j].range[1] <== 9;

            rangeProof[i][j].in <== add.out[i][j];

            rangeProof[i][j].out === 1;
        }
    }

    // check all rows and columns and blocks sum to 45 and sum of sqaures = 285 and product = 9! = 362880

    component row[9];
    component col[9];
    component block[9];
    component rowSq[9];
    component colSq[9];
    component blockSq[9];
    component rowProd[9];
    component colProd[9];
    component blockProd[9];


    for (var k=0; k<9; k++) {
        row[k] = matElemSum(1,9);
        col[k] = matElemSum(1,9);
        block[k] = matElemSum(3,3);

        rowSq[k] = matElemSum(1,9);
        colSq[k] = matElemSum(1,9);
        blockSq[k] = matElemSum(3,3);

        rowProd[k] = Multiplier9();
        colProd[k] = Multiplier9();
        blockProd[k] = Multiplier9();

        for (var i=0; i<9; i++) {
            row[k].a[0][i] <== add.out[k][i];
            col[k].a[0][i] <== add.out[i][k];

            rowSq[k].a[0][i] <== square.out[k][i];
            colSq[k].a[0][i] <== square.out[i][k];

            rowProd[k].in[i] <== add.out[k][i];
            colProd[k].in[i] <== add.out[i][k];
        }
        var x = 3*(k%3);
        var y = 3*(k\3);
        var idx = 0;
        for (var i=0; i<3; i++) {
            for (var j=0; j<3; j++) {
                block[k].a[i][j] <== add.out[x+i][y+j];
                blockSq[k].a[i][j] <== square.out[x+i][y+j];
                blockProd[k].in[idx] <== add.out[x+i][y+j];
                idx++;
            }
        }
        row[k].out === 45;
        col[k].out === 45;
        block[k].out === 45;

        rowSq[k].out === 285;
        colSq[k].out === 285;
        blockSq[k].out === 285;

        rowProd[k].out === 362880;
        colProd[k].out === 362880;
        blockProd[k].out === 362880;
    }

    // hash the original puzzle and emit so that the dapp can listen for puzzle solved events
    
    component poseidon[9];
    
    for (var i=0; i<9; i++) {
        poseidon[i] = Poseidon(9);
        for (var j=0; j<9; j++) {
            poseidon[i].inputs[j] <== puzzle[i][j];
        }
    }

    out <== poseidon[0].out + poseidon[1].out + poseidon[2].out + poseidon[3].out + poseidon[4].out + poseidon[5].out + poseidon[6].out + poseidon[7].out + poseidon[8].out;
}

component main = sudoku();