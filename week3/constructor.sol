// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract X {
    string public name;

    constructor(string memory _name) { name = _name; }
}

contract Y {
    string public text;
    constructor(string memory _text) { text = _text; }
}

contract B is X("Input to X"), Y("Input to Y") {
}