//SPDX-License-Identifier: UNLICENSE
pragma solidity ^0.7.0;

import "hardhat/console.sol";

/** @dev Defines a list of possible rules on data subjects
 */
enum rule
  {
    DoNotProcess,
    OnlyAggregated,
    DoNotTransfer,
    OnlyTransferAggregated,
    DoNotJoin
    // TODO: complete list
  }

/** @dev Defines a couple (subject, restriction) to compose a SLA
 */
struct statement {
  string subject;
  rule restriction;
}

/** @dev Describes a Service Level Agreement (SLA) in compact form
 *
 * It stores some general information, such as a url where the dataset can be found,
 * plus a list of constraints on how it can be used
 */
struct Sla {
  string description;
  string dataset_url;
  address owner;
  mapping (uint => statement) statements;
}

/** @dev Implementation of a smart contract that stores SLAs
 *
 * It stores minimal information about the SLA and who published it, alongside with a
 * pointer to the actual dataset involved.
 */
contract SlaStorage {

  event NewSla(string description, string dataset_url, address owner);

  mapping (string => Sla) agreements;

  constructor() {
    console.log("Deploying a SlaStorage contract");
  }

  function getSla(string memory id) external view returns (statement[] memory sla) {
    statement[] memory sla = new statement[] (agreements[id].sizeOfMapping);
    for (uint i = 0; i < agreements[id].sizeOfMapping; i++) {
      sla[i] = agreements.myMappingInStruct[i];
    }
  }

  function getSlaDatasetUrl(string memory id) external view returns (string memory) {
    return agreements[id].dataset_url;
  }

  function getSlaDescription(string memory id) external view returns (string memory) {
    return agreements[id].description;
  }

  function getSlaOwner(string memory id) external view returns (string memory) {
    return agreements[id].owner;
  }

  // TOFIX: structs cannot be passed as parameter 
  function new(string calldata id, string calldata description, string calldata dataset_url, statement[] calldata sla) external {
    Sla memory agreement;
    agreement.description = description;
    agreement.dataset_url = dataset_url;
    agreement.owner = msg.sender;
    for (uint i = 0; i < sla.length; i++) {
      agreement.statements[i] = sla[i];
    }
    agreements[id] = agreement;
    emit NewSla(description, dataset_url, msg.sender);
    console.log("new SLA: '%s', owned by '%s'", description, msg.sender);
  }

  function delete(string memory id) external {
    require(msg.sender == agreements[id].owner,
            "only the owner is allowed to deleta a SLA");
    console.log("deleted SLA '%s', owned by '%s', description: '%s'",
                id, msg.sender, agreements[id].description);
    delete agreements[id];
  }
}





