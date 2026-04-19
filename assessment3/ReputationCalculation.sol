// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// TODO: Add better error handling
contract ReputationCalculation {
    address public complaintRegistry;

    mapping(uint => uint) public totalScore;
    mapping(uint => uint) public reviewCount;
    mapping(uint256 => mapping(uint256 => bool)) public hasRated;
    mapping(uint256 => mapping(uint256 => uint256)) public userRating;

    event ScoreAdded(uint256 indexed orgId, uint256 indexed userId, uint256 score);
    event ScoreUpdated(uint256 indexed orgId, uint256 indexed userId, uint256 oldScore, uint256 newScore);

    modifier onlyComplaintRegistry() {
        require(msg.sender == complaintRegistry, "Only ComplaintRegistry can call");
        _;
    }

    constructor() {
        complaintRegistry = msg.sender;
    }

    function updateExistingScore (uint orgId, uint256 userId, uint newScore) private 
        returns (uint oldScore) 
    {
        oldScore = userRating[orgId][userId];
        totalScore[orgId] = totalScore[orgId] - oldScore + newScore;
        userRating[orgId][userId] = newScore;
        return oldScore;
    }

    function updateScore(uint orgId, uint256 userId, uint score) public onlyComplaintRegistry {
        require(score >= 1 && score <= 10, "Score must be between 1 and 10");

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

    // TODO: FIND A BETTER SCORE CALCULATION SYSTEM (ELO LIKE?)
    function getScore(uint orgId) public view returns (uint) {
        if (reviewCount[orgId] == 0) { return 0; }
        return totalScore[orgId] / reviewCount[orgId];
    }

    //TODO: ADD GET TOP SCORES
}