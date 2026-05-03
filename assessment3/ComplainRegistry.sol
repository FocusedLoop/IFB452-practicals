// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./OrganisationRegistry.sol";
import "./UserRegistry.sol";
import "./ReputationCalculation.sol";

contract ComplaintRegistry {
    struct Complaint {
        uint id;
        uint userId;
        uint orgId;
        uint score;
        uint timestamp;
        string contentHash;
        address reporter;
    }

    uint256 public complaintCount;

    mapping(uint256 => Complaint) public complaints;
    mapping(uint256 => uint256[]) public complaintsByOrganisation;
    mapping(uint256 => uint256[]) public complaintsByUser;

    OrganisationRegistry public organisationRegistry;
    UserRegistry public userRegistry;
    ReputationCalculation public reputationCalculation;

    event ComplaintSubmitted(
        uint256 indexed complaintId,
        uint256 indexed userId,
        uint256 indexed orgId,
        uint256 score,
        address reporter,
        string contentHash 
    );

    constructor (address organisationRegistryAddress, address userRegistryAddress, address reputationCalculationAddress) {
        require(organisationRegistryAddress != address(0), "Invalid org registry");
        require(userRegistryAddress != address(0), "Invalid user registry");
        require(reputationCalculationAddress != address(0), "Invalid reputation contract");

        organisationRegistry = OrganisationRegistry(organisationRegistryAddress);
        userRegistry = UserRegistry(userRegistryAddress);
        reputationCalculation = ReputationCalculation(reputationCalculationAddress);
    }

    // TODO: HAVE AN OPTION TO USE ABN INSTEAD OF ID
    // Submit a complaint about an organisation
    function submitComplaint(uint256 userId, uint256 orgId, uint256 score, string memory contentHash) external returns (uint256) {
        require(bytes(contentHash).length > 0, "Complaint hash required");
        require(userRegistry.userExists(userId), "Invalid user");
        require(organisationRegistry.organisationExists(orgId), "Organisation does not exist");

        complaintCount++;

        complaints[complaintCount] = Complaint({
            id: complaintCount,
            userId: userId,
            orgId: orgId,
            score: score,
            timestamp: block.timestamp,
            contentHash: contentHash,
            reporter: msg.sender
        });

        complaintsByOrganisation[orgId].push(complaintCount);
        complaintsByUser[userId].push(complaintCount);

        reputationCalculation.updateScore(orgId, userId, score);

        emit ComplaintSubmitted(complaintCount, userId, orgId, score, msg.sender, contentHash);

        return complaintCount;
    }

    // Get complaints for an organisation given its ID
    function getComplaints(uint256 orgId) external view returns (Complaint[] memory) {
        require(organisationRegistry.organisationExists(orgId), "Organisation does not exist");
        uint256[] memory ids = complaintsByOrganisation[orgId];
        Complaint[] memory result = new Complaint[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            result[i] = complaints[ids[i]];
        }
        return result;
    }
}