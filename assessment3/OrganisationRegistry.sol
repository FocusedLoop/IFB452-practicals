// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract OrganisationRegistry
{
    struct Organisation {
        uint registrationNumber;
        string name;
    }

    // Mapping from Organisation registration number to Organisation details
    uint256 public organisationCount;
    mapping(uint256 => Organisation) private organisations;
    Organisation[] private organisationList;

    event OrganisationRegistered(uint256 indexed orgRegistrationNumber, string name);
    
    function registerOrganisation(uint256 registrationNumber, string calldata name) external returns (uint256)
    {
        require(bytes(name).length > 0, "Organisation name required");
        require(isValidRegistrationNumber(registrationNumber), "Invalid registration number");
        require(!organisationExists(registrationNumber), "Registration number already registered");

        // Register Organisation
        organisations[registrationNumber] = Organisation({
            registrationNumber: registrationNumber,
            name: name
        });

        // Increment organisation count and track registrationNumber
        organisationCount++;
        organisationList.push(organisations[registrationNumber]);

        emit OrganisationRegistered(registrationNumber, name);
        return registrationNumber;
    }

    // Validate registration number (example: ABN or ACN format)
    function isValidRegistrationNumber(uint256 registrationNumber) internal pure returns (bool)
    {
        return registrationNumber >= 10000000 && registrationNumber <= 999999999999999;
    }

    // Check if an organisation exists by registration number
    function organisationExists(uint256 registrationNumber) public view returns (bool)
    {
        bool exists = organisations[registrationNumber].registrationNumber != 0;
        return exists;
    }

    // Check if an organisation exists by registration number
    function getOrganisation(uint256 registrationNumber) external view returns (uint256 id, string memory name)
    {
        require(organisationExists(registrationNumber), "Organisation does not exist");
        Organisation memory org = organisations[registrationNumber];
        return (org.registrationNumber, org.name);
    }

    // List all organisations
    function listOrganisations() external view returns (Organisation[] memory)
    {
        return organisationList;
    }
}