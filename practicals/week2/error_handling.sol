// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Error {
    function testRequire(uint _i) public pure { require(_i > 10, "Inputt must be greater than 10!"); }

    function testRevert(uint _i) public pure {
        if (_i <= 10) { revert("Inputt must be greater than 10!"); }
    }
    uint public num;

    function testAssert() public view { assert(num == 0); }
}