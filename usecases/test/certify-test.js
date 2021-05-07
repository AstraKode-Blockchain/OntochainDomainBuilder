const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Certify", function() {
  it("issued certificates can be proven corectly", async function() {
    const Certify = await ethers.getContractFactory("Certify");
    const name = "certo";
    const url = name + ".com"
    const certify = await Certify.deploy(name, url);
    
    await certify.deployed();
    expect(await certify.certification_body_name()).to.equal(name);

    const cert = 'plastic-free'
    const expiry = parseInt(Date.now() / 1000) + 3600
    const [owner1, addr1] = await ethers.getSigners();
    await certify.issue(addr1.address, cert, expiry);
    expect(await certify.num_certificates(addr1.address)).to.equal(1);
    expect(await certify.connect(addr1).prove(cert));
    // TODO test that expired or non-existent certificates cannot be proven
  });
});
