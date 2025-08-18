# Balance Drop Trap

A Solidity smart contract that monitors wallet balance drops and triggers alerts when sudden significant decreases are detected. This trap is designed to work with the Drosera monitoring framework to provide real-time security monitoring for Ethereum wallets.

## Overview

The `BalanceDropTrap` contract implements the `ITrap` interface to monitor a target wallet's ETH balance and detect sudden drops that exceed a configurable threshold. When a significant balance decrease is detected between consecutive blocks, the trap triggers an alert with detailed information about the drop.

## Key Features

- **Real-time Balance Monitoring**: Continuously tracks ETH balance of a specified target wallet
- **Configurable Threshold**: Set custom percentage thresholds for balance drop detection (default: 20%)
- **Consecutive Block Validation**: Ensures data integrity by validating consecutive block numbers
- **Detailed Alert Information**: Provides comprehensive data when a drop is detected
- **Gas Efficient**: Optimized for minimal gas consumption during monitoring

## Configuration

### Constants

```solidity
uint256 private constant DROP_THRESHOLD = 20; // 20% threshold
uint256 private constant BASIS_POINTS = 10000; // 100% = 10000 basis points
address public constant TARGET_WALLET = 0x1234567890aBCDef1234567890AbcDEF12345678;
```

- **DROP_THRESHOLD**: Percentage threshold for triggering alerts (default: 20%)
- **BASIS_POINTS**: Used for precise percentage calculations
- **TARGET_WALLET**: The wallet address to monitor (update with your target address)

## Use Cases

### 1. **DeFi Protocol Security Monitoring**

Monitor treasury wallets or critical protocol addresses for unexpected fund movements:

```
Scenario: A DeFi protocol's treasury wallet suddenly loses 25% of its ETH balance
Result: Immediate alert triggered, enabling rapid incident response
Benefits: Early detection of potential exploits, governance attacks, or admin key compromises
```

### 2. **Whale Wallet Surveillance**

Track large holders' movements for market intelligence:

```
Scenario: A known whale wallet experiences a 30% balance drop in one block
Result: Alert provides detailed information about the balance change
Benefits: Market participants can react to large movements, potential market impact analysis
```

### 3. **Smart Contract Exploit Detection**

Monitor vulnerable contracts or recently deployed protocols:

```
Scenario: A newly deployed contract loses significant funds due to an exploit
Result: Trap detects the sudden balance drop and triggers security protocols
Benefits: Faster incident response, potential circuit breaker activation
```

### 4. **Personal Wallet Security**

Monitor your own wallets for unauthorized transactions:

```
Scenario: Your personal wallet balance drops by 50% unexpectedly
Result: Immediate notification allows for quick security assessment
Benefits: Early detection of compromised private keys or unauthorized access
```

### 5. **Exchange Hot Wallet Monitoring**

Monitor exchange hot wallets for security breaches:

```
Scenario: An exchange's hot wallet experiences an unexpected 40% balance drop
Result: Alert triggers automated security protocols
Benefits: Rapid response to potential exchange hacks, user fund protection
```

### 6. **DAO Treasury Oversight**

Monitor DAO treasury wallets for unauthorized spending:

```
Scenario: DAO treasury balance drops significantly without proper governance approval
Result: Community receives immediate alert about unauthorized fund movement
Benefits: DAO governance protection, transparency in fund management
```

### 7. **MEV Protection Monitoring**

Track wallets that might be targets of MEV attacks:

```
Scenario: A wallet involved in large trades experiences unexpected balance drops
Result: Detection of potential sandwich attacks or MEV exploitation
Benefits: Better understanding of MEV impact, protection strategy development
```

### 8. **Cross-Chain Bridge Monitoring**

Monitor bridge contracts for sudden fund outflows:

```
Scenario: A cross-chain bridge contract loses 35% of its ETH balance
Result: Alert indicates potential bridge exploit or mass withdrawal
Benefits: Early warning system for bridge security issues
```

## Technical Specifications

### Data Collection

The `collect()` function returns:
- Current ETH balance of the target wallet
- Current block number for data validation

### Alert Triggering Logic

The `shouldRespond()` function evaluates:
1. **Data Sufficiency**: Requires at least 2 data points for comparison
2. **Block Continuity**: Validates consecutive block numbers
3. **Balance Comparison**: Calculates percentage drop between consecutive blocks
4. **Threshold Check**: Triggers alert if drop exceeds configured threshold

### Alert Data Structure

When triggered, the trap returns:
```solidity
abi.encode(
    "ALERT: Sudden balance drop detected!",
    TARGET_WALLET,           // Monitored address
    previousBalance,         // Balance before drop
    currentBalance,          // Current balance
    dropPercentage,          // Percentage of drop (in basis points)
    previousBlock,           // Previous block number
    currentBlock            // Current block number
)
```

## Integration Examples

### With Monitoring Systems

```javascript
// Example monitoring integration
const trap = new ethers.Contract(trapAddress, trapABI, provider);

// Collect data every block
provider.on('block', async (blockNumber) => {
    const data = await trap.collect();
    // Store data and check for alerts
    const shouldAlert = await trap.shouldRespond([previousData, data]);
    if (shouldAlert[0]) {
        // Handle alert
        handleBalanceDropAlert(shouldAlert[1]);
    }
});
```

### With Notification Systems

```javascript
function handleBalanceDropAlert(alertData) {
    const [message, wallet, prevBalance, currBalance, dropPercentage] = 
        ethers.utils.defaultAbiCoder.decode(
            ['string', 'address', 'uint256', 'uint256', 'uint256', 'uint256', 'uint256'],
            alertData
        );
    
    // Send notifications via Slack, Discord, email, etc.
    sendSlackAlert({
        text: `🚨 ${message}`,
        wallet: wallet,
        drop: `${dropPercentage / 100}%`,
        amount: ethers.utils.formatEther(prevBalance - currBalance)
    });
}
```

## Deployment and Configuration

1. **Update Target Wallet**: Modify `TARGET_WALLET` constant to your desired monitoring address
2. **Adjust Threshold**: Modify `DROP_THRESHOLD` for your sensitivity requirements
3. **Deploy Contract**: Deploy to your preferred Ethereum network
4. **Integrate with Drosera**: Connect the trap to your Drosera monitoring setup

## Security Considerations

- The `collect()` function uses `view` modifier to minimize gas costs when reading blockchain state
- The `shouldRespond()` function uses `pure` modifier as it only processes input data without reading state
- All calculations use basis points to avoid floating-point precision issues
- Input validation prevents reverts that could break monitoring
- Consecutive block validation ensures data integrity

## Gas Optimization

The contract is optimized for monitoring scenarios:
- Minimal storage usage (only constants)
- `collect()` function uses `view` for efficient blockchain state reading
- `shouldRespond()` function uses `pure` for gas-free data processing
- Efficient percentage calculations using integer arithmetic
- No external calls or complex logic in critical paths

## License

This contract is released under the MIT License, making it freely available for use, modification, and distribution.

---

*This trap is designed to work with the Drosera monitoring framework. Ensure proper integration and testing before deploying to mainnet.*