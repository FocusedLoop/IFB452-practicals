// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ReputationCalculation {
    address public owner;
    address public complaintRegistry;

    // Mapping from organisation ID to total score and review count
    mapping(uint => uint) public totalScore;
    mapping(uint => uint) public reviewCount;
    mapping(uint256 => mapping(uint256 => bool)) private hasRated;
    mapping(uint256 => mapping(uint256 => uint256)) private userRating; // Per user

    event ScoreAdded(uint256 indexed orgId, uint256 userId, uint256 score);
    event ScoreUpdated(uint256 indexed orgId, uint256 userId, uint256 oldScore, uint256 newScore);

    // Lock in the ComplaintRegistry address to restrict who can update scores
    modifier onlyComplaintRegistry() {
        require(msg.sender == complaintRegistry, "Only ComplaintRegistry can call");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Set the ComplaintRegistry address
    function setComplaintRegistry(address desired_complaintRegistry) external 
    {
        // Added check for zero address, check to ensure address can only be set once and restrict owner
        require(desired_complaintRegistry != address(0), "Invalid address"); //
        require(complaintRegistry == address(0), "Complaint registry already set");
        require(msg.sender == owner, "Only owner can set");

        // Set the complaint registry address and remove traces of ownership
        complaintRegistry = desired_complaintRegistry;
        delete owner;
    }

    // Update score for an organisation by a user
    function updateExistingScore (uint orgId, uint256 userId, uint newScore) private returns (uint oldScore) 
    {
        oldScore = userRating[orgId][userId];
        totalScore[orgId] = totalScore[orgId] - oldScore + newScore;
        userRating[orgId][userId] = newScore;
        return oldScore;
    }

    // Update score for an organisation by a user
    function updateScore(uint orgId, uint256 userId, uint score) public onlyComplaintRegistry {
        require(score >= 1 && score <= 10, "Score must be between 1 and 10");

        // If the user has already rated, update their score, otherwise add a new score
        if (hasRated[orgId][userId]) {
            uint oldScore = updateExistingScore(orgId, userId, score);

            emit ScoreUpdated(orgId, userId, oldScore, score);
        } else {
            totalScore[orgId] += score;
            reviewCount[orgId] += 1;
            hasRated[orgId][userId] = true;
            userRating[orgId][userId] = score;

            emit ScoreAdded(orgId, userId, score);
        }
    }

    // Get average score for an organisation
    function getScore(uint orgId) public view returns (uint) {
        if (reviewCount[orgId] == 0) { return 0; }
        return totalScore[orgId] / reviewCount[orgId];
    }
}