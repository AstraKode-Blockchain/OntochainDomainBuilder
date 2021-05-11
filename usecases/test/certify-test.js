const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Certify", function() {
  it("issued certificates can be proven corectly", async function() {
    const Certify = await ethers.getContractFactory("Certify");
    const name = "certo";
    const url = name + ".com"
    const [owner1, addr1, addr2, addr3] = await ethers.getSigners();
    const certify = await Certify.connect(addr1).deploy(name, url);

    await certify.deployed();
    expect(await certify.certificationBodyName()).to.equal(name);

    const cert = 'plastic-free'
    const expiry = parseInt(Date.now() / 1000) + 3600
    await certify.issue(addr2.address, cert, expiry);
    expect(await certify.numCertificates(addr2.address)).to.equal(1);
    expect(await certify.connect(addr2).prove(cert));
    expect(await certify.connect(addr3).isValid(addr2.address, cert)).to.be.true;
    // TODO test that expired or non-existent certificates cannot be proven
  });
});
