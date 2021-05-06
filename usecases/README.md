DomainBuilder Usecases
===

# Setup

This setup works in any debian-based linux distributions which use `apt` as package manager; it was tested on debian 10. To use other distributions or to run it on windows, follow the installation instructions of the various dependencies and it should work regardless.

First we need `npm`, whose installation instructions can be found [here](https://www.npmjs.com/get-npm).

In order to compile, run tests or manually try out the the usecases provided here, you need to install the requred, dependecies, among which `hardhat`. So, starting from the project root, run:
```bash=
cd usecases
npm install
```
It's now time to build a basic setup for `hardhat`. The following command is interactive, choose "Create an empty hardhat.config.js" when asked:
```bash=
npx hardhat
```

# Usage
The following sections describe how to interact with this system.

## Compile and deploy a smart contract

In order to compile solidity smartcontracts into EVM bytecode, run:
```bash=
npx hardhat compile
```
Then you can deploy it by running the corresponding script (example for certify):
```bash=
npx run scripts/certify_deploy.js
```

## Interact with a deployed smart contract

TODO

