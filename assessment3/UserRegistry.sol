// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract UserRegistry {
    struct User {
        uint id;
        string name;
        address wallet;
    }

    uint256 public userCount;
    mapping(uint256 => User) private users;
    mapping(address => bool) private  isRegistered;
    mapping(address => uint256) private walletToUserId;

    event UserRegistered(uint256 indexed userId, string name);

    // Register a new user
    function registerUser(string calldata name) external returns (uint256) {
        require(bytes(name).length > 0, "User name required");
        require(!isRegistered[msg.sender], "Wallet already in use");
        
        userCount++;
        users[userCount] = User({
            id: userCount,
            name: name,
            wallet: msg.sender
        });

        // Mark wallet as registered
        isRegistered[msg.sender] = true;
        walletToUserId[msg.sender] = userCount;

        emit UserRegistered(userCount, name);
        return userCount;
    }

    // Retrieve user details by ID
    function getUser(uint256 userId) external view returns (uint256 id, string memory name)
    {
        require(userExists(userId), "User does not exist");
        User memory user = users[userId];
        return (user.id, user.name);
    }

    // Check if a wallet address is the owner of a user ID
    function isOwner(uint256 userId, address wallet) external view returns (bool) {
        require(userExists(userId), "User does not exist");
        return users[userId].wallet == wallet;
    }

    // Check if a user exists by ID
    function userExists(uint256 userId) public view returns (bool) {
        return userId > 0 && userId <= userCount;
    }
}