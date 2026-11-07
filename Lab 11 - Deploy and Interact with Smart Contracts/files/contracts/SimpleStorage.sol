// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedData;
    event DataStored(uint256 indexed newValue, address indexed sender);
    constructor(uint256 initialValue) {
        storedData = initialValue;
        emit DataStored(initialValue, msg.sender);
    }
    function set(uint256 newValue) public {
        storedData = newValue;
        emit DataStored(newValue, msg.sender);
    }
    function get() public view returns (uint256) {
        return storedData;
    }
    function increment() public {
        storedData += 1;
        emit DataStored(storedData, msg.sender);
    }
    function getInfo() public view returns (uint256 value, address contractAddress) {
        return (storedData, address(this));
    }
}
