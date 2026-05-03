// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Event {
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hellow World!");
        emit AnotherLog();
    }
}