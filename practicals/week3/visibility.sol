// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Base {
    // Inside contract, not inherited
    function privateFunc() private pure returns (string memory) { return "private function called"; }

    function testPrivateFunc() public pure returns (string memory) { return privateFunc(); }
    
    // Inside contract, is inherited
    function internalFunc() internal pure returns (string memory) { return "private function called"; }

    function testInternalFunc() public pure virtual returns (string memory) { return internalFunc(); }
}