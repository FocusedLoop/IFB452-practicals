// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Variables {

    // Saved to blockchain
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public {
        // Not saved to blockchain
        uint i = 456;
        uint timestamp = block.timestamp;
        address sender = msg.sender;
    }
}