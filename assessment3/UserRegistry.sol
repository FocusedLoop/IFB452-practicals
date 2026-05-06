// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract UserRegistry {
    struct User {
        uint id;
        string name;
        address wallet;
    }

    uint256 public userCount;
    mapping(uint256 => User) public users;
    mapping(address => bool) public isRegistered;
    mapping(address => uint256) public walletToUserId;

    event UserRegistered(uint256 indexed userId, string name, address indexed wallet);

    // Register a new user
    function registerUser(string memory name) external returns (uint256) {
        require(bytes(name).length > 0, "User name required");

        // DEBUG: COMMENT OUT FOR DEMONSTRATION AND TESTING PURPOSES
        // require(!isRegistered[msg.sender], "Wallet already in use");
        
        userCount++;

        users[userCount] = User({
            id: userCount,
            name: name,
            wallet: msg.sender
        });

        // Mark wallet as registered
        // DEBUG: COMMENT OUT FOR DEMONSTRATION AND TESTING PURPOSES
        // isRegistered[msg.sender] = true;
        // walletToUserId[msg.sender] = userCount;

        emit UserRegistered(userCount, name, msg.sender);
        return userCount;
    }

    // TODO: REFACTOR
    // Debug
    // Get user details by ID
    function getUser(uint256 userId) external view
        returns (uint256 id, string memory name, address wallet)
    {
        require(userExists(userId), "User does not exist");
        User memory user = users[userId];
        return (user.id, user.name, user.wallet);
    }

    // Check if a user exists by ID
    function userExists(uint256 userId) public view returns (bool) {
        return userId > 0 && userId <= userCount;
    }
}