// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// TODO ADD BNB AS SOURCE OF ID
// TODO ADD USER AS ADMIN OF ORGANISATION
contract OrganisationRegistry {
    struct Organisation {
        uint id;
        string name;
        address owner;
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
            owner: msg.sender
        });

        emit OrganisationRegistered(organisationCount, name, msg.sender);
        return organisationCount;
    }

    function organisationExists(uint256 orgId) public view returns (bool) {
        return orgId > 0 && orgId <= organisationCount;
    }

    function getOrganisation(uint256 orgId) external view returns (uint256 id, string memory name, address owner)
    {
        require(organisationExists(orgId), "Organisation does not exist");
        Organisation memory org = organisations[orgId];
        return (org.id, org.name, org.owner);
    }
}