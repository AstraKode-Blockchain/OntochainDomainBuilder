//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.0;

import "hardhat/console.sol";

/** @dev Representation of the required metadata for the certification body
 *
 * The address alone is strictly required for the contract to work correctly
 */
struct CertificationBody {
  address addr;
  string name;
  string url;
}

/** @dev Representation of the required public data for a certified entity
 *
 * The certification holder can autonomously update its private data at will
 */
struct Holder {
  string name;
  string url;
}

/** @dev Collects certificates issued to a given holder
 *
 * Other than the certificates themselves, it stores the amount of certifications a holder has.
 * This is needed in order to verify if an address really represents a certificate holder
 */
struct Certs {
  uint num_certs;
  mapping (string => uint) certs;
}

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
contract Certify {

  event HoldsCertificate(address _holder, string _cert);
  event IssuedCertificate(address _holder, string _cert, uint _expiry);

  CertificationBody certificationBody;
  mapping (address => Certs) certificates;
  mapping (address => Holder) publicData;

  constructor(string memory name, string memory url) {
    console.log("Deploying a Certify contract");
    certificationBody = CertificationBody(msg.sender, name, url);
  }

  function certificationBodyName() external view returns (string memory) {
    return certificationBody.name;
  }

  function numCertificates(address holder) external view returns (uint) {
    return certificates[holder].num_certs;
  }

  function isValid(address holder, string memory cert) external view returns (bool) {
    console.log("address '%s' holds certificate '%s', which is valid until '%s'",
                holder, cert, certificates[holder].certs[cert]);
    return certificates[holder].certs[cert] > block.timestamp;
  }

  function issue(address holder, string memory cert, uint expiry) external {
    require(msg.sender == certificationBody.addr,
            "only certification body is allowed to issue certificates");
    require(expiry > block.timestamp,
            "certificate already expired");
    certificates[holder].certs[cert] = expiry;
    certificates[holder].num_certs += 1;
    emit IssuedCertificate(holder, cert, expiry);
    console.log("issued '%s' to address '%s', will expire at: '%s'",
                cert, holder, expiry);
  }

  function revoke(address holder, string memory cert) external {
    require(msg.sender == certificationBody.addr,
            "only certification body is allowed to revoke certificates");
    // require(certificates[holder].certs[cert] <= block.timestamp,
    //         "only expired certificates can be revoked")
    console.log("revoked '%s' from address '%s', would have expired at: '%s'",
                cert, msg.sender, certificates[holder].certs[cert]);
    certificates[holder].certs[cert] = 0;
    certificates[holder].num_certs -= 1;
  }

  function prove(string memory cert) external {
    require(certificates[msg.sender].certs[cert] >= block.timestamp,
            "sender does not own certificate or it expired");
    emit HoldsCertificate(msg.sender, cert);
    console.log("'%s' address has valid certificate: '%s'", msg.sender, cert);
  }

  function updateData(string memory name, string memory url) external {
    require(certificates[msg.sender].num_certs != 0,
            "only certificate holders can update their public data");
    publicData[msg.sender] = Holder(name, url);
  }
}





