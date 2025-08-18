// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResponseTrap {
    event TrapTriggered(bool triggered, bytes responseData, uint256 timestamp);
    
    bool public lastTriggered;
    bytes public lastResponseData;
    uint256 public lastResponseTime;
    
    constructor() {}
    
    function response(bool triggered, bytes memory responseData) external {
        lastTriggered = triggered;
        lastResponseData = responseData;
        lastResponseTime = block.timestamp;
        
        emit TrapTriggered(triggered, responseData, block.timestamp);
    }
}