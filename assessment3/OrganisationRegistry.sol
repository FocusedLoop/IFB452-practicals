// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract OrganisationRegistry {
    struct Organisation {
        uint id;
        string name;
        address owner;
        
        bool exists; // REMOVE
    }

    // TODO: REPLACE WITH OFF CHAIN
    uint256 public organisationCount;
    mapping(uint256 => Organisation) public organisations;

    event OrganisationRegistered(uint256 indexed orgId, string name, address indexed owner);
    
    function registerOrganisation(string memory name) external returns (uint256) {
        require(bytes(name).length > 0, "Organisation name required");

        organisationCount++;

        organisations[organisationCount] = Organisation({
            id: organisationCount,
            name: name,
            owner: msg.sender,
            exists: true
        });

        emit OrganisationRegistered(organisationCount, name, msg.sender);
        return organisationCount;
    }

    function organisationExists(uint256 orgId) external view returns (bool) {
        return organisations[orgId].exists;
    }

    function getOrganisation(uint256 orgId) external view
        returns (uint256 id, string memory name, address owner, bool exists) {
        Organisation memory org = organisations[orgId];
        return (org.id, org.name, org.owner, org.exists);
    }
}