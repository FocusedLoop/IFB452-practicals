// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// TODO: ADD WALLET
// TODO FIX isVerified issue
contract UserRegistry {
    struct User {
        uint id;
        string name;
        bool exists; // REMOVE
        bool isVerified;
    }

    uint256 public userCount;
    mapping(uint256 => User) public users;

    event UserRegistered(uint256 indexed userId, string name, address indexed);
    event UserVerified(uint256 indexed userId, bool isVerified);

    function registerUser(string memory name) external returns (uint256) {
        require(bytes(name).length > 0, "User name required");
        userCount++;

        users[userCount] = User({
            id: userCount,
            name: name,
            exists: true,
            isVerified: true // change to false if you want manual approval later
        });

        emit UserRegistered(userCount, name, msg.sender);
        return userCount;
    }

    function verifyUser(uint256 userId, bool verified) external {
        require(users[userId].exists, "User does not exist");
        users[userId].isVerified = verified;
        emit UserVerified(userId, verified);
    }

    // TODO: REFACTOR
    function getUser(uint256 userId) external view
        returns (uint256 id, string memory name, bool exists, bool isVerified)
    {
        User memory user = users[userId];
        return (user.id, user.name, user.exists, user.isVerified);
    }

    function userExists(uint256 userId) external view returns (bool) {
        return users[userId].exists;
    }

    function isVerifiedUser(uint256 userId) external view returns (bool) {
        return users[userId].isVerified;
    }
}