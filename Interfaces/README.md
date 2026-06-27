# Solidity Interfaces

## Overview

This project demonstrates the purpose of **interfaces** in Solidity.

An interface defines **what functions a contract must have**, but it does **not** define how those functions work.

Think of an interface as a contract's public API. It allows other contracts to interact with a contract without needing to know its internal implementation.

---

## Files

### IERC20.sol

Defines the ERC20-like interface.

The interface only declares function signatures:

* `transfer()`
* `transferFrom()`
* `balanceOf()`

No function bodies or business logic exist inside the interface.

---

### MockToken.sol

Implements the `IERC20` interface.

This contract contains the actual logic for:

* updating balances
* transferring tokens
* returning balances

The interface describes the functions, while the contract implements them.

---

### Vault.sol

Demonstrates how interfaces are used in practice.

The vault interacts with a token through the `IERC20` interface instead of relying on a specific token implementation.

Because of this, the vault can work with **any token contract that follows the IERC20 interface**.

---

## Why Interfaces Exist

Without interfaces, contracts would need to know the exact implementation of every external contract they interact with.

Interfaces provide a common language between contracts.

This allows independent contracts to communicate with each other while remaining loosely coupled.

---

## Key Takeaway

Interfaces focus on **what a contract can do**.

Contracts focus on **how it does it**.

```text
Interface  → Defines functionality
Contract   → Implements functionality
```

In this example:

```text
IERC20  → defines transfer(), transferFrom(), balanceOf()

MockToken → implements transfer(), transferFrom(), balanceOf()

Vault → interacts with MockToken through IERC20
```

This separation is one of the foundations of smart contract interoperability.
