# Delegatecall — The Foundation of Upgradeable Proxies

## Overview

This project demonstrates the core idea behind `delegatecall`.

Instead of executing its own code, a contract can execute the code of another contract while **keeping its own storage, address, and state**.

This separation between **code** and **storage** is the foundation of almost every upgradeable proxy pattern used in Solidity.

---

## Project Structure

```
Proxy
    │
delegatecall
    ▼
CounterLogic
```

- **Proxy** owns the storage.
- **CounterLogic** owns the business logic.

When `delegatecall` is used:

- The code executes inside `CounterLogic`.
- The storage that is modified belongs to `Proxy`.

---

## Why Not Use `call()`?

A normal `call()` executes another contract's code **using that contract's storage**.

```
Proxy
   │
 call()
   ▼
Logic

Storage Modified → Logic
```

This is not useful for upgradeable contracts because all state would live inside the logic contract.

`delegatecall()` changes this behavior.

```
Proxy
      │
delegatecall()
      ▼
Logic

Code Executed → Logic

Storage Modified → Proxy
```

The logic contract behaves like a reusable piece of code, while the proxy permanently owns all user state.

---

## Why Is This Important?

Imagine a lending protocol.

Version 1 contains:

- deposit()
- withdraw()

Months later you release Version 2:

- deposit()
- withdraw()
- borrow()
- repay()

Without a proxy, users must migrate to a completely new contract.

With a proxy:

```
User
   │
   ▼
Proxy
   │
   ▼
Logic V1

↓

Upgrade

↓

User
   │
   ▼
Proxy
   │
   ▼
Logic V2
```

The proxy address never changes.

Only the implementation contract changes.

All user balances remain inside the proxy.

---

## Storage Layout

One of the most important rules when using `delegatecall` is that **both contracts must have the same storage layout**.

```solidity
uint256 public counter;
```

occupies **storage slot 0** in both contracts.

When `CounterLogic` executes:

```solidity
counter++;
```

it believes it is modifying its own variable.

However, because execution happens through `delegatecall`, slot `0` actually belongs to the `Proxy`.

As a result, the proxy's storage is updated.

---

## MY NOTES 

- ABI : Defines exactly how those bytes are constructed.
- Encoded bytes does not contain any information about what they represent.
- Function Identifier : Keccak256 hash of function signature ->  Extract first 4 bytes -> Becomes selector.
- Low Level Calls - When the function is not known at Compile time.
- CallData : Encoded argument into one byte array called call data.
- Proxies : Fake Contract that users interact with.
- Proxies use DelegateCall().
- What does it do -> implementation.delegatecall(msg.data)
- implementation : Go to logic contract.
- delegatecall : Execute code but use my storage.
- msg.data : Exact bytes user send me.

## Key Takeaways

- `call()` → Uses another contract's **code and storage**.
- `delegatecall()` → Uses another contract's **code**, but **your storage**.
- The proxy owns the data.
- The implementation owns the logic.
- This separation enables upgradeable smart contracts.
