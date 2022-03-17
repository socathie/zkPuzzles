#!/bin/bash

cd circuits
mkdir -p build

mkdir -p build/sudoku

# generate witness
node "build/sudoku_js/generate_witness.js" build/sudoku_js/sudoku.wasm input.json build/sudoku/witness.wtns
        
# generate proof
snarkjs plonk prove build/sudoku/circuit_final.zkey build/sudoku/witness.wtns build/sudoku/proof.json build/sudoku/public.json

# verify proof
snarkjs plonk verify build/sudoku/verification_key.json build/sudoku/public.json build/sudoku/proof.json

# generate call
snarkjs zkey export soliditycalldata build/sudoku/public.json build/sudoku/proof.json > build/sudoku/call.txt