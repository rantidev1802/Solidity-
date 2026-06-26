# Solidity Notes: Constant vs Immutable

## Objective

Understand when to use `constant` and `immutable`, how they differ internally, and why production protocols use them.

---

## Theory

### `constant`

A constant is known at compile time. The compiler replaces every occurrence of the variable with its literal value, so it is never stored in contract storage.

```solidity
uint256 public constant COLLATERAL_FACTOR = 70;
```

Use `constant` when the value is identical for every deployment.

Examples:

* Precision values
* Basis points
* Mathematical constants
* Protocol limits

---

### `immutable`

An immutable variable is assigned exactly once during contract deployment inside the constructor. After deployment, it becomes read-only.

```solidity
address public immutable owner;

constructor() {
    owner = msg.sender;
}
```

Use `immutable` when every deployment may have a different value.

Examples:

* Oracle address
* WETH address
* Treasury
* Owner

---

## Code Example

```solidity
contract Example {
    uint256 public constant PRECISION = 1e18;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }
}
```

---

## Key Differences

| constant                  | immutable                       |
| ------------------------- | ------------------------------- |
| Compile-time value        | Deployment-time value           |
| Same for every deployment | Can differ per deployment       |
| Cannot use constructor    | Must be assigned in constructor |
| Never changes             | Never changes after deployment  |

---

## What I Learned

* `constant` is ideal for protocol parameters that never change.
* `immutable` avoids unnecessary storage reads while allowing deployment-specific configuration.
* Both are cheaper than reading regular storage variables.

---

## Real Protocol Examples

```solidity
uint256 constant LIQUIDATION_THRESHOLD = 80;
address immutable CHAINLINK_ORACLE;
address immutable WETH;
```

---

## References

* Solidity Documentation
* My own implementation and experiments
