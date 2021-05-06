//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.0;

import "hardhat/console.sol";

/** @dev Implementation of a smart contract that handles certifications
 *
 * It stores minimal information about the certificate in its storage so
 * that it becomes available to the public if deployed on a public blockchain.
 * The certification body alone is able to issue certificates and it cannot
 * delete them.
 *
 * For now we simplify the structure by only identifying the certificate holder
 * with its address for privacy reasons. The structure can be easily extended
 * to also include further information on the holder.
 */
contract Cert {

  event HoldsCertificate(address _holder, string _cert);
  event IssuedCertificate(address _holder, string _cert, uint _expiry);

  address private _certification_body;
  // mapping (holder => (certificate => expiry))
  mapping (address => mapping (string => uint)) _certificates;

  constructor() {
    console.log("Deploying a Cert");
    _certification_body = msg.sender;
  }

  function issue(address holder, string memory cert, uint expiry) public {
    require(msg.sender == _certification_body,
            "only certification body is allowed to issue certificates");
    require(expiry > block.timestamp,
            "certificate already expired");
    _certificates[holder][cert] = expiry;
    emit IssuedCertificate(holder, cert, expiry);
    console.log("issued '%s' to address '%s', will expire at: '%s'",
                cert, msg.sender, expiry);
  }

  function prove(string memory cert) public {
    require(_certificates[msg.sender][cert] >= block.timestamp,
            "sender does not own certificate or it expired");
    emit HoldsCertificate(msg.sender, cert);
    console.log("'%s' address has valid certificate: '%s'", msg.sender, cert);
  }
}
