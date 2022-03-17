const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");

describe("Verifier Contract", function () {
    let Verifier;
    let verifier;

    beforeEach(async function () {
        Verifier = await ethers.getContractFactory("PlonkVerifier");
        verifier = await Verifier.deploy();
        await verifier.deployed();
    });

    it("Should return true for correct proofs", async function () {
        var text = fs.readFileSync("./circuits/build/sudoku/call.txt", 'utf-8');
        var calldata = text.split(',');
        //console.log(calldata);
        expect(await verifier.verifyProof(calldata[0], JSON.parse(calldata[1]))).to.be.true;
    });
    it("Should return false for invalid proof", async function () {
        let a = '0x00';
        let b = ['0'];
        expect(await verifier.verifyProof(a, b)).to.be.false;
    });
});