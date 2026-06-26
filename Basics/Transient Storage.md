# ⚡ Transient Storage (EIP-1153)

Transient storage is a temporary data location introduced in **EIP-1153**. Like regular storage, it stores data as key-value pairs, but its contents exist **only for the duration of a single transaction**. Once the transaction completes (whether successfully or after a revert), the data is automatically cleared.

Since transient storage is **not written to the blockchain's permanent state**, it is significantly cheaper than persistent storage.

## Key Features

* ⚡ Lower gas cost than persistent storage.
* ⏳ Data exists only during the current transaction.
* 🧹 Automatically resets to zero after the transaction ends.
* 🔒 Accessible only by the contract that owns it.
* 🚫 Currently supports only value types (e.g., `bool`, `uint256`, `address`).

## Common Use Cases

* Reentrancy guards
* Temporary execution flags
* Sharing data between internal calls within the same transaction
* Gas-efficient protocol state management

## Example

```solidity
bool transient locked;

modifier nonReentrant() {
    require(!locked, "Reentrant call");
    locked = true;
    _;
    locked = false;
}
```

## Persistent Storage vs Transient Storage

| Persistent Storage                  | Transient Storage                               |
| ----------------------------------- | ----------------------------------------------- |
| Data is stored permanently on-chain | Data exists only during the current transaction |
| Higher gas cost                     | Lower gas cost                                  |
| Uses `SSTORE` / `SLOAD`             | Uses `TSTORE` / `TLOAD`                         |
| Suitable for protocol state         | Suitable for temporary execution state          |

## Important Notes

* Available only on **Cancun** EVM and newer.
* Reading (`TLOAD`) is allowed in `STATICCALL`, but writing (`TSTORE`) is not.
* If a call reverts, all transient storage writes made within that call are also reverted.

## Key Takeaway

Think of **persistent storage** as a database that permanently stores your protocol's state. Think of **transient storage** as temporary RAM—it holds data only while a transaction is executing and is automatically erased afterward, making it ideal for short-lived, gas-efficient state management.
