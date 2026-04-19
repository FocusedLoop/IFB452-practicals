// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

// Receive Ether ensure msg.data is not empty and return balance
contract ReceiveEther {
    receive() external payable {}
    fallback() external payable {}

    // Difference between receive and fallback is there is a way to say the contract can get ETH as normal
    // fallback handles the unexpected
    function getBalance() public view returns (uint256) { return address(this).balance; }
}

// Send Ether through different methods
contract SendEther {
    function sendViaTransfer(address payable _to) public payable { _to.transfer(msg.value); }

    function sendViaSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    // function sendViaCall(address payable _to) public payable {
    //     (bool sent, bytes memory data) = _to.call{value: msg.value}("");
    //     require(sent, "Failed to send Ether");
    // }
}