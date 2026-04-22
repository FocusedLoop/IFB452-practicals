// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// TODO: ADD WALLET
contract UserRegistry {
    struct User {
        uint id;
        string name;
        //address wallet
    }

    uint256 public userCount;
    mapping(uint256 => User) public users;

    event UserRegistered(uint256 indexed userId, string name, address indexed);

    function registerUser(string memory name) external returns (uint256) {
        require(bytes(name).length > 0, "User name required");
        userCount++;

        users[userCount] = User({
            id: userCount,
            name: name
        });

        emit UserRegistered(userCount, name, msg.sender);
        return userCount;
    }

    // TODO: REFACTOR
    function getUser(uint256 userId) external view
        returns (uint256 id, string memory name)
    {
        require(userExists(userId), "Organisation does not exist");
        User memory user = users[userId];
        return (user.id, user.name);
    }

    function userExists(uint256 userId) public view returns (bool) {
        return userId > 0 && userId <= userCount;
    }
}