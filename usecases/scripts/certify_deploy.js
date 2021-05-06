// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Cert = await hre.ethers.getContractFactory("Cert");
  const cert = await Cert.deploy();

  await cert.deployed();

  console.log("Cert deployed to:", cert.address);

  await cert.issue('0x5fbdb2315678afecb367f032d93f642f64180aa3',
                   'plastic_free', 2234560000);
  await cert.prove('plastic_free');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

