# Solidity Libraries

## Overview

This project demonstrates how **libraries** are used in Solidity.

A library contains reusable code that can be shared across multiple contracts.

Instead of writing the same logic in every contract, the logic is written once inside a library and reused wherever it is needed.

In this example, the library performs percentage calculations that could be used in lending protocols, staking contracts, vaults, or fee systems.

---

## Files

### PercentageMath.sol

Contains reusable percentage calculation functions.

Functions included:

* `percentOf()`
* `addPercentage()`
* `subtractPercentage()`

These functions are generic and can be reused by any contract.

---

### FeeVault.sol

Demonstrates how a contract can use a library.

Instead of implementing percentage calculations itself, the contract imports `PercentageMath` and reuses its functions.

This keeps the contract smaller, cleaner, and easier to maintain.

---

## Why Libraries Exist

Imagine building five different DeFi protocols.

Every protocol needs to calculate:

* protocol fees
* staking rewards
* interest
* percentages

Without libraries, the same code would be copied into every contract.

Libraries solve this by allowing common logic to be written once and reused many times.

---

## Library vs Interface

| Interface                                        | Library                                            |
| ------------------------------------------------ | -------------------------------------------------- |
| Defines **what** functions a contract must have. | Implements **how** common tasks are performed.     |
| Contains only function declarations.             | Contains executable function implementations.      |
| Used for communication between contracts.        | Used for code reuse.                               |
| Has no business logic.                           | Contains business logic.                           |
| Makes contracts interoperable.                   | Makes contracts cleaner and avoids duplicate code. |

---

## Key Takeaway

A library is a collection of reusable logic.

It is **not** another contract that defines rules for communication.

```text
Interface
    ↓
Defines what exists

Library
    ↓
Implements reusable logic
```

In this example:

```text
PercentageMath
        ↓
Reusable percentage calculations

FeeVault
        ↓
Uses the library instead of rewriting the calculations
```

The main purpose of libraries is to improve code reuse, readability, and maintainability.
