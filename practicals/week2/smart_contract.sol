// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// Defining Exam Score for a student
contract ExamScoreContract {

    address public singleStudent;
    uint256 public examScore;

    // Check who can send this
    modifier onlyStudent() {
        require(msg.sender == singleStudent, "Only student can execute this");
        _;
    }

    // Validate Amount
    modifier validScore(uint newScore) {
        require(newScore <= 100, "score should be in the range 0...100");
        _;
    }

    // Push notifications
    event ExamScoreUpdated(uint256 newScore);

    // Constructor to say what is valid/invalid
    constructor(address initialStudent) {
        require(initialStudent != address(0), "Invalid initial student address");
        singleStudent = initialStudent;
        examScore = 0;
    }

    // authorisation control
    function updateScore(uint256 newScore)
        external
        onlyStudent
        validScore(newScore)
    {
        examScore = newScore;
        emit ExamScoreUpdated(newScore);
    }
}