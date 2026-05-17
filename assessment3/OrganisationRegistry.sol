// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// TODO ONLY ALLOW USERS TO REGISTER ORGANISATIONS WITH NO LINKING
contract OrganisationRegistry {
    struct Organisation {
        uint abn; // TODO LOOK AT BETTER NAMING SCHEMA SHOULD SUPPORT EIN, IRD
        string name;
    }

    // Mapping from ABN to Organisation details
    uint256 public organisationCount;
    mapping(uint256 => Organisation) private organisations;
    Organisation[] private abnList;

    event OrganisationRegistered(uint256 indexed orgAbn, string name);
    
    function registerOrganisation(uint256 abn, string memory name) external returns (uint256)
    {
        require(bytes(name).length > 0, "Organisation name required");
        require(abn >= 10000000000 && abn <= 99999999999, "Invalid ABN"); // TODO: MAKE BETTER ABN VALIDATION
        require(!organisationExists(abn), "ABN already registered");

        // Register Organisation
        organisations[abn] = Organisation({
            abn: abn,
            name: name
        });

        // Increment organisation count and track ABN
        organisationCount++;
        abnList.push(organisations[abn]);

        emit OrganisationRegistered(abn, name);
        return abn;
    }

    // Check if an organisation exists by ABN
    function organisationExists(uint256 abn) public view returns (bool)
    {
        bool exists = organisations[abn].abn != 0;
        return exists;
    }

    // Check if an organisation exists by ABN
    function getOrganisation(uint256 abn) external view returns (uint256 id, string memory name)
    {
        require(organisationExists(abn), "Organisation does not exist");
        Organisation memory org = organisations[abn];
        return (org.abn, org.name);
    }

    // List all organisations
    function listOrganisations() external view returns (Organisation[] memory)
    {
        return abnList;
    }
}