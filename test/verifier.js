const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");

describe("Verifier Contract", function () {
    let Verifier;
    let verifier;

    beforeEach(async function () {
        Verifier = await ethers.getContractFactory("Verifier");
        verifier = await Verifier.deploy();
        await verifier.deployed();
    });

    it("Should return true for correct proofs", async function () {
        var array = JSON.parse("[" + fs.readFileSync("./circuits/build/sudoku/call.json") + "]");
        expect(await verifier.verifyProof(array[0], array[1], array[2], array[3])).to.be.true;
    });
    it("Should return false for invalid proof", async function () {
        let a = [0, 0];
        let b = [[0, 0], [0, 0]];
        let c = [0, 0];
        let d = [0];
        expect(await verifier.verifyProof(a, b, c, d)).to.be.false;
    });
});