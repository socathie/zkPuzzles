#!/bin/bash

#export NODE_OPTIONS="--max-old-space-size=16384"

cd circuits
mkdir -p build

if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

echo "Compiling: sudoku..."

mkdir -p build/sudoku

# compile circuit

circom sudoku.circom --r1cs --wasm --sym -o build
snarkjs r1cs info build/sudoku.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup build/sudoku.r1cs powersOfTau28_hez_final_16.ptau build/sudoku/circuit_final.zkey #circuit_0000.zkey
#snarkjs zkey contribute build/sudoku/circuit_0000.zkey build/sudoku/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey build/sudoku/circuit_final.zkey build/sudoku/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier build/sudoku/circuit_final.zkey ../contracts/verifier.sol