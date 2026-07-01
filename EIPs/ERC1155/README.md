# ERC-1155 — Multi Token Standard

## Overview

ERC-1155 is Ethereum's **Multi-Token Standard**. Unlike ERC-20 (one fungible token per contract) and ERC-721 (one NFT collection per contract), ERC-1155 allows a **single smart contract to manage multiple token types simultaneously**.

One contract can contain:

* Fungible tokens (Gold Coins)
* Non-Fungible Tokens (Legendary Sword)
* Semi-Fungible Tokens (Concert Tickets)
* Any future asset represented by a unique Token ID.

Its biggest innovation is treating every asset as an entry in the same ledger instead of deploying a separate contract for every asset.

---

# Motivation

Before ERC-1155, applications with many asset types had two options:

* Deploy one ERC-20 contract for every currency.
* Deploy one ERC-721 contract for every NFT collection.

For applications like blockchain games, this quickly became inefficient.

Example:

```
Gold Coin
Silver Coin
Potion
Sword
Shield
Armor
Dragon Egg
Event Badge
```

Using previous standards, every asset (or collection) would require its own contract, resulting in:

* Higher deployment costs
* Duplicate contract logic
* Multiple approval systems
* More transactions
* Higher gas consumption

ERC-1155 solved this by introducing:

> **One Contract → Multiple Asset Types**

---

# Why ERC-1155 Exists

The core idea is simple:

Instead of identifying an asset by **Contract Address**, ERC-1155 identifies it using:

```
Contract Address
        +
     Token ID
```

Each Token ID represents a different asset.

Example:

```
Game Contract

ID 1 → Gold
ID 2 → Potion
ID 3 → Sword
ID 4 → Dragon Egg
```

Every balance is stored inside one contract.

---

# Core Concepts

## 1. Multi-Token Standard

A single contract can represent unlimited asset types.

Instead of:

```
Gold Contract
Sword Contract
Potion Contract
```

ERC-1155 stores

```
Game Contract

ID 1 → Gold
ID 2 → Sword
ID 3 → Potion
```

---

## 2. Token IDs

Every asset is identified using a numeric ID.

```
ID 1 → Gold

ID 2 → Potion

ID 3 → Sword
```

The unique identifier becomes

```
Contract Address + Token ID
```

instead of deploying a new contract.

---

## 3. Unified Balance Storage

Balances are stored as

```solidity
mapping(uint256 => mapping(address => uint256)) balances;
```

Meaning

```
balances[tokenId][owner]
```

Example

```
balances[1][Alice] = 500 Gold

balances[2][Alice] = 1 Sword

balances[3][Bob] = 25 Potions
```

---

## 4. Fungible & Non-Fungible Together

ERC-1155 does not distinguish assets by contract.

Only balances matter.

Examples:

```
Gold

Alice = 500
Bob = 200
```

```
Sword

Alice = 1
Bob = 0
```

```
Potion

Alice = 10
Bob = 35
```

The same storage model supports every asset type.

---

## 5. Batch Operations

ERC-1155 introduces native batch operations.

Instead of

```
Transfer Gold

Transfer Sword

Transfer Potion
```

You perform

```
Transfer all together
```

Benefits:

* Lower gas
* Fewer transactions
* Better user experience

---

## 6. Metadata

Metadata is shared through a URI template.

Example

```
https://game.com/items/{id}.json
```

Wallets replace `{id}` with the actual Token ID to fetch metadata.

---

# Architecture

```
User

│

safeTransferFrom()

│

_checkAuthorized()

│

_safeTransferFrom()

│

_updateWithAcceptanceCheck()

│

_update()

│

Balances Updated
```

Every transfer, mint and burn eventually reaches the same accounting engine.

---

# Internal Accounting Engine

The heart of ERC-1155 is:

```solidity
_update(...)
```

It is responsible for:

* Verifying balances
* Updating balances
* Supporting minting
* Supporting burning
* Supporting transfers
* Emitting events

Instead of separate accounting logic for every operation, OpenZeppelin funnels every state change into one internal function.

This dramatically reduces duplicate code and simplifies auditing.

---

# Public Functions

### `balanceOf(address account, uint256 id)`

Returns the balance of one Token ID owned by an account.

---

### `balanceOfBatch(address[] accounts, uint256[] ids)`

Returns balances for multiple Token IDs in one call.

Introduced to avoid multiple RPC requests and improve efficiency.

---

### `safeTransferFrom(...)`

Transfers one Token ID safely.

Also verifies that receiving smart contracts can accept ERC-1155 tokens.

---

### `safeBatchTransferFrom(...)`

Transfers multiple Token IDs in a single transaction.

One of ERC-1155's biggest improvements over ERC-20 and ERC-721.

---

### `setApprovalForAll(...)`

Approves an operator to manage **all Token IDs** owned by the user inside the contract.

ERC-1155 intentionally removes per-token approvals to simplify asset management.

---

### `isApprovedForAll(...)`

Checks whether an operator has permission to transfer assets.

---

### `uri(uint256 id)`

Returns the metadata URI template for a Token ID.

---

# Internal Functions

### `_update()`

The accounting engine.

Every transfer, mint and burn eventually reaches this function.

---

### `_updateWithAcceptanceCheck()`

Updates balances and then verifies whether the receiving contract accepts ERC-1155 tokens.

---

### `_mint()`

Creates new tokens by transferring assets from the zero address.

---

### `_burn()`

Destroys tokens by transferring assets to the zero address.

---

### `_setApprovalForAll()`

Stores operator approvals.

---

### `_setURI()`

Updates the metadata URI template.

---

# Mental Models

## Spreadsheet

Imagine a spreadsheet.

| User  | Gold | Sword | Potion |
| ----- | ---- | ----- | ------ |
| Alice | 100  | 1     | 12     |
| Bob   | 50   | 0     | 8      |

Rows represent users.

Columns represent Token IDs.

ERC-1155 simply updates this spreadsheet.

---

## Warehouse

Think of a warehouse.

Each shelf stores a different product.

```
Shelf 1 → Gold

Shelf 2 → Potion

Shelf 3 → Sword
```

The warehouse is the smart contract.

The shelf number is the Token ID.

---

## Video Game Inventory

A player's inventory contains:

* Coins
* Weapons
* Armor
* Potions
* Skins

No game creates a separate inventory system for every item.

ERC-1155 follows the same philosophy.

---

# Real World Use Cases

### Blockchain Games

The primary use case.

A single contract can manage:

* Weapons
* Armor
* Resources
* Currencies
* Collectibles
* Event Items

---

### NFT Games

Trading card games, RPG inventories and crafting systems benefit heavily from batch operations.

---

### Ticketing

Concert tickets.

Sports tickets.

VIP passes.

General admission tickets.

Multiple ticket types can exist inside one contract.

---

### Loyalty Programs

One contract can issue:

* Reward Points
* Coupons
* Membership Badges
* Discount Vouchers

---

### Supply Chain

Different product SKUs can be represented as different Token IDs.

Inventory becomes directly trackable on-chain.

---

### Digital Collectibles

Card packs, gaming skins, achievements and digital merchandise all fit naturally into ERC-1155.

---

# Why ERC-1155 Matters

ERC-1155 wasn't created to replace ERC-20 or ERC-721.

It was created to solve a scalability problem.

Instead of deploying one contract per asset, developers deploy **one contract that manages an entire ecosystem of assets**.

This reduces deployment costs, improves gas efficiency, enables batch operations and greatly simplifies application architecture.

---

# Security Considerations

* Always use safe transfer functions.
* Never bypass authorization checks.
* Validate batch array lengths.
* Verify sufficient balances before updating storage.
* Perform external acceptance checks **after** updating state (Checks → Effects → Interactions).
* Centralize balance modifications in a single internal accounting function (`_update()`).

---

# Key Takeaways

* ERC-1155 is a **Multi-Token Standard**.
* One contract can represent unlimited asset types.
* Assets are identified by **Contract Address + Token ID**.
* Supports fungible, non-fungible and semi-fungible assets.
* Introduces native batch transfers and batch balance queries.
* Uses a single accounting engine (`_update()`) for transfers, minting and burning.
* Optimized for games, marketplaces, ticketing systems and digital asset platforms where many asset types coexist.
