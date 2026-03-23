// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Payable {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    // Functions to alter that contract
    function deposit() public payable {}
    function notPayable() public {}

    // Withdraw all Ether from this contract
    function withdraw() public {
        uint amount = address(this).balance;
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    // Transfer Ether from this contract to address
    function transfer(address payable _to, uint _amount) public {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}