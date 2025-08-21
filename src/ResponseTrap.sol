// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResponseTrap {
    event TrapTriggered(bool triggered, bytes responseData, uint256 timestamp);

    bool public lastTriggered;
    bytes public lastResponseData;
    uint256 public lastResponseTime;

    address public operator;

    constructor() {
        operator = msg.sender;
    }

    modifier onlyOperator() {
        require(msg.sender == operator, "Not authorized");
        _;
    }

    function setOperator(address newOperator) external onlyOperator {
        require(newOperator != address(0), "Invalid address");
        operator = newOperator;
    }

    function response(bool triggered, bytes memory responseData) external onlyOperator {
        lastTriggered = triggered;
        lastResponseData = responseData;
        lastResponseTime = block.timestamp;

        emit TrapTriggered(triggered, responseData, block.timestamp);
    }
}