// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

contract BalanceDropTrap is ITrap {
    uint256 private constant DROP_THRESHOLD = 20;
    uint256 private constant BASIS_POINTS = 10000;
    
    address public constant TARGET_WALLET = 0xaBC1234567890DeFAbC1234567890DefABc12345;
    
    constructor() {}
    
    function collect() external view returns (bytes memory) {
        uint256 currentBalance = TARGET_WALLET.balance;
        uint256 currentBlock = block.number;
        
        return abi.encode(currentBalance, currentBlock);
    }
    
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length < 2) {
            return (false, abi.encode("Insufficient data points"));
        }
        
        (uint256 previousBalance, uint256 previousBlock) = abi.decode(data[0], (uint256, uint256));
        (uint256 currentBalance, uint256 currentBlock) = abi.decode(data[1], (uint256, uint256));
        
        if (currentBlock != previousBlock + 1) {
            return (false, abi.encode("Data not from consecutive blocks"));
        }
        
        if (previousBalance == 0) {
            return (false, abi.encode("No previous balance to compare"));
        }
        
        if (currentBalance >= previousBalance) {
            return (false, abi.encode("No balance drop detected"));
        }
        
        uint256 drop = previousBalance - currentBalance;
        uint256 dropPercentage = (drop * BASIS_POINTS) / previousBalance;
        
        bool shouldTrigger = dropPercentage >= (DROP_THRESHOLD * BASIS_POINTS / 100);
        
        if (shouldTrigger) {
            bytes memory responseData = abi.encode(
                "ALERT: Sudden balance drop detected!",
                TARGET_WALLET,
                previousBalance,
                currentBalance,
                dropPercentage,
                previousBlock,
                currentBlock
            );
            return (true, responseData);
        } else {
            bytes memory responseData = abi.encode(
                "Balance drop below threshold",
                dropPercentage,
                DROP_THRESHOLD * 100
            );
            return (false, responseData);
        }
    }
}