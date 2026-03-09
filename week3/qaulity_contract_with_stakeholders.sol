// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract QualityContract {

    // Track which addresses
    mapping(address => bool) public stakeholders;
    uint256 public qualityScore;

    modifier onlyStakeholder() {
        require(stakeholders[msg.sender], "Only authorised stakeholder can execute this");
        _;
    }

    // Accept a list of addresses and registers them as stakeholders
    constructor(address[] memory initialStakeholders) {
        for (uint256 i = 0; i < initialStakeholders.length; i++) {
            stakeholders[initialStakeholders[i]] = true;
        }
        qualityScore = 0;
    }

    // Allow a stakeholder to update the quality score
    function updateQualityScore(uint256 newScore)external onlyStakeholder {
        qualityScore = newScore;
    }

    // Allows an existing stakeholder to add another stakeholder
    function addStakeholder(address newStakeholder)external onlyStakeholder {
        stakeholders[newStakeholder] = true;
    }
}