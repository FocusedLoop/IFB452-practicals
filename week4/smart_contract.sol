// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract QualityContract {
    address public owner;

    // Contract
    struct QualityContractData {
        string contractName;
        address[] stakeholders;
        string qualityCriteria;
        bool isComplated;
    }

    // Create a map of quality contract information
    mapping (uint => QualityContractData) public qualityContracts;
    uint256 public contractCount;

    // When event triggered create contract and assign ownership
    event QualityContractCreated(uint256 contractId, string contractName, address[] stakeholders, string qualityCriteria);
    constructor() { owner = msg.sender; }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    //NOTE: Go over "memory" concept
    // 
    function createQualityContract(string memory _contractName, address[] memory _stakeholders, string memory _qualityCriteria) public onlyOwner {
        contractCount++;
        qualityContracts[contractCount] = QualityContractData(_contractName, _stakeholders, _qualityCriteria, false);
        emit QualityContractCreated(contractCount, _contractName, _stakeholders, _qualityCriteria);
    }

    function completeQualityContract(uint256 _contractId) public onlyOwner {
        require(_contractId > 0 && _contractId <= contractCount, "Invalid contract ID");
        qualityContracts[_contractId].isCompleted = true;
        
    }
}