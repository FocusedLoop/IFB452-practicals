// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./OrganisationRegistry.sol";
import "./UserRegistry.sol";
import "./ReputationCalculation.sol";

contract ComplaintRegistry {
    struct Complaint {
        uint id;
        uint userId;
        uint orgRegistrationNumber;
        uint score;
        uint timestamp;
        string review;
    }

    uint256 public complaintCount;

    // Mapping from complaint ID to Complaint details
    mapping(uint256 => Complaint) private complaints;
    mapping(uint256 => uint256[]) private complaintsByOrganisation;
    mapping(uint256 => mapping(uint256 => uint256)) private latestComplaintByUser;

    OrganisationRegistry public organisationRegistry;
    UserRegistry public userRegistry;
    ReputationCalculation public reputationCalculation;

    event ComplaintSubmitted(
        uint256 indexed complaintId,
        uint256 indexed userId,
        uint256 indexed orgRegistrationNumber,
        uint256 score,
        string review 
    );

    // Initialize with addresses of the other contracts and set requirements
    constructor (address organisationRegistryAddress, address userRegistryAddress, address reputationCalculationAddress)
    {
        require(organisationRegistryAddress != address(0), "Invalid org registry");
        require(userRegistryAddress != address(0), "Invalid user registry");
        require(reputationCalculationAddress != address(0), "Invalid reputation contract");

        organisationRegistry = OrganisationRegistry(organisationRegistryAddress);
        userRegistry = UserRegistry(userRegistryAddress);
        reputationCalculation = ReputationCalculation(reputationCalculationAddress);
    }

    // Submit a complaint about an organisation
    function submitComplaint(uint256 userId, uint256 orgRegistrationNumber, uint256 score, string calldata review) external returns (uint256)
    {
        require(reputationCalculation.complaintRegistry() == address(this), "ReputationCalculation Contract must reference this contract");
        require(bytes(review).length > 0, "Review required");
        require(userRegistry.userExists(userId), "Invalid user");
        require(organisationRegistry.organisationExists(orgRegistrationNumber), "Organisation does not exist");
        require(userRegistry.isOwner(userId, msg.sender), "Not your account");


        // Create complaint and update mappings
        uint256 existingComplaintId = latestComplaintByUser[orgRegistrationNumber][userId];
        uint256 complaintId;

        if(existingComplaintId == 0) {
            // Create new complaint if user hasn't sumbitted a complaint before
            complaintCount++;

            complaints[complaintCount] = Complaint({
                id: complaintCount,
                userId: userId,
                orgRegistrationNumber: orgRegistrationNumber,
                score: score,
                timestamp: block.timestamp,
                review: review
            });

            latestComplaintByUser[orgRegistrationNumber][userId] = complaintCount;
            
            complaintsByOrganisation[orgRegistrationNumber].push(complaintCount);

            complaintId = complaintCount;

        } else {
            // Update existing complaint if user has submitted a complaint before
            Complaint storage c = complaints[existingComplaintId];

            c.score = score;
            c.review = review;
            c.timestamp = block.timestamp;

            complaintId = existingComplaintId;
        }

        // Track complaints by organisation and update reputation
        
        reputationCalculation.updateScore(orgRegistrationNumber, userId, score);
        emit ComplaintSubmitted(complaintId, userId, orgRegistrationNumber, score, review);
        return complaintId;
    }

    // Get complaints for an organisation given its ID
    function getComplaints(uint256 orgRegistrationNumber) external view returns (Complaint[] memory)
    {
        require(organisationRegistry.organisationExists(orgRegistrationNumber), "Organisation does not exist");
        uint256[] memory ids = complaintsByOrganisation[orgRegistrationNumber];
        Complaint[] memory result = new Complaint[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            result[i] = complaints[ids[i]];
        }
        return result;
    }
}