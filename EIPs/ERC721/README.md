# ERC-721 — The Standard for Unique Digital Assets

## What is ERC-721?

ERC-721 is the standard interface for **non-fungible tokens (NFTs)** on Ethereum.

Unlike ERC-20, where every token is identical and interchangeable, every ERC-721 token is **unique** and has its own identity represented by a `tokenId`.

Think of ERC-721 as a **universal ownership registry** rather than an image standard.

The blockchain doesn't care about JPEGs or artwork—it only records **who owns a specific asset**.

---

# Motivation

Before ERC-721, Ethereum had ERC-20, which was perfect for representing **fungible assets** like currencies or governance tokens.

ERC-20 answers:

> **How much does Alice own?**

But many real-world assets cannot be represented by balances alone.

Examples include:

- Houses
- Event tickets
- University certificates
- Digital art
- Domain names
- Collectibles
- Game items

For these assets, **identity matters more than quantity**.

Owning two houses is meaningless unless you know **which two houses**.

ERC-20 cannot represent this because it only tracks balances.

ERC-721 solves this by giving every asset a **unique identifier (`tokenId`)** and tracking ownership of each token individually.

---

# Why ERC-721 Exists

ERC-721 introduced a standardized way to represent **ownership of unique assets**.

Instead of storing

```
Alice → 100 Tokens
```

it stores

```
Token #1 → Alice
Token #2 → Bob
Token #3 → Charlie
```

This simple shift changes Ethereum from a platform that represents **value** into one that represents **ownership**.

---

# Core Principle

ERC-20 stores ownership by **balance**.

```
Address
      ↓
Balance
```

ERC-721 stores ownership by **identity**.

```
Token ID
      ↓
Owner
```

Instead of asking

> "How many tokens does Alice own?"

ERC-721 asks

> "Who owns Token #25?"

---

# Mental Models

## 1. Government Property Registry

Imagine a government land registry.

```
Property ID          Owner
----------------------------
101                  Alice
102                  Bob
103                  Charlie
```

The government does **not** store the houses.

It stores **ownership records**.

ERC-721 works exactly the same way.

---

## 2. Vehicle Registration

Think of `tokenId` like a vehicle registration number.

```
DL01AB1234

↓

Alice
```

The registration number uniquely identifies a car.

Similarly,

```
Token #81

↓

Alice
```

uniquely identifies an NFT.

---

## 3. Database Primary Key

`tokenId` is simply a **primary key**.

```
Token ID

↓

Unique Record

↓

Owner
```

It identifies an asset.

It does **not** determine its value.

---

# Internal State

Conceptually, every ERC-721 contract maintains three important pieces of information.

### Ownership

```
Token ID

↓

Owner
```

Implemented conceptually as

```solidity
mapping(uint256 => address) ownerOfToken;
```

---

### Balance

```
Owner

↓

Number of NFTs Owned
```

Conceptually

```solidity
mapping(address => uint256) balances;
```

This allows wallets to instantly know how many NFTs an address owns.

---

### Approvals

```
Token

↓

Approved Address
```

and

```
Owner

↓

Operator

↓

Can Manage All NFTs
```

These permissions allow marketplaces and protocols to transfer NFTs on behalf of users.

---

# Important Functions

## balanceOf(address owner)

Returns the number of NFTs owned by an address.

**Purpose**

Allows wallets, explorers, and applications to quickly determine ownership count without scanning every NFT.

---

## ownerOf(uint256 tokenId)

Returns the owner of a specific NFT.

**Purpose**

This is the most important function in ERC-721.

Ownership is tracked **per token**, not per balance.

---

## transferFrom()

Transfers ownership of an NFT.

**Purpose**

Moves a specific NFT from one owner to another after verifying permissions.

---

## safeTransferFrom()

Safely transfers an NFT.

Before transferring to a smart contract, it verifies that the receiving contract understands ERC-721.

If not, the transaction reverts.

**Purpose**

Prevents NFTs from becoming permanently locked inside contracts.

---

## approve()

Approves another address to transfer **one specific NFT**.

Useful for:

- Selling an NFT
- Auctions
- Escrow

---

## setApprovalForAll()

Approves an operator to manage **all NFTs owned by the caller**.

Useful for:

- NFT marketplaces
- Games
- Vaults

---

## getApproved()

Returns the approved address for a specific NFT.

---

## isApprovedForAll()

Returns whether an operator has permission to manage all NFTs owned by an address.

---

# Metadata Extension

ERC-721 does **not** store artwork.

Instead it stores a reference.

```
Token #51

↓

Metadata URI

↓

IPFS / HTTPS

↓

JSON

↓

Image
Traits
Description
```

The blockchain stores ownership.

Metadata describes **what that ownership represents**.

---

# Approval Model

Ownership and permission are two different concepts.

Alice may own an NFT while OpenSea has permission to transfer it.

```
Owner

↓

Alice

↓

Approves

↓

Marketplace

↓

Marketplace Transfers

↓

Buyer
```

This enables decentralized marketplaces without giving custody to the marketplace.

---

# Why safeTransferFrom Exists

Suppose Alice sends an NFT to a contract that doesn't support NFTs.

Without safety checks,

the NFT becomes permanently locked.

`safeTransferFrom()` prevents this by requiring the receiving contract to implement:

```solidity
onERC721Received(...)
```

If the contract doesn't support ERC-721,

the transaction reverts.

---

# Minting

Minting creates a brand-new ownership record.

Before

```
Token #200

↓

Does Not Exist
```

After

```
Token #200

↓

Alice
```

Minting emits

```
Transfer(
    address(0),
    Alice,
    tokenId
)
```

---

# Burning

Burning removes the ownership record.

Before

```
Token #200

↓

Alice
```

After

```
Token #200

↓

Does Not Exist
```

Burning emits

```
Transfer(
    Alice,
    address(0),
    tokenId
)
```

---

# ERC-721 vs ERC-20

| ERC-20 | ERC-721 |
|----------|----------|
| Represents value | Represents ownership |
| Fungible | Non-Fungible |
| Tracks balances | Tracks unique identities |
| Every token is identical | Every token is unique |
| `balanceOf()` is primary | `ownerOf()` is primary |
| Quantity matters | Identity matters |

---

# Security Considerations

## Always prefer safeTransferFrom()

Never use `transferFrom()` when sending NFTs to unknown smart contracts.

`safeTransferFrom()` prevents assets from becoming permanently locked.

---

## Clear Approvals After Transfer

Approvals must be removed whenever ownership changes.

Otherwise previous operators could still transfer the NFT after it has been sold.

---

## Verify Token Existence

Functions like

```
ownerOf(tokenId)
```

should revert for nonexistent tokens instead of returning `address(0)`.

---

## Metadata Should Not Be Trusted Blindly

The blockchain guarantees ownership.

It does **not** guarantee that off-chain metadata is available forever.

Applications should account for missing or changing metadata.

---

## Ownership Is the Source of Truth

The image,

traits,

description,

or marketplace listing

do **not** determine ownership.

The owner mapping inside the ERC-721 contract is the only canonical source of truth.

---

# Key Takeaways

- ERC-721 standardizes ownership of unique digital assets.
- Every NFT is identified by a unique `tokenId`.
- Ownership is tracked per token, not by balances.
- Metadata is separate from ownership.
- Approvals enable decentralized marketplaces.
- `safeTransferFrom()` prevents NFTs from being trapped in contracts.
- Minting creates ownership.
- Burning removes ownership.
- ERC-721 is fundamentally an **ownership registry**, not an image standard.

---

# Summary

ERC-721 transformed Ethereum from a platform capable of representing **fungible value** into one capable of representing **unique ownership**.

Its real innovation is not NFTs or digital art—it is the standardization of ownership itself.

By assigning every asset a unique identity (`tokenId`) and providing a common interface for ownership, transfers, approvals, and metadata, ERC-721 enabled wallets, marketplaces, games, identity systems, ticketing platforms, and countless other applications to interoperate without custom integrations.

The core idea to remember is simple:

> **ERC-20 answers "How much do you own?"**
>
> **ERC-721 answers "Which specific asset do you own?"**

Everything else in the standard exists to support that single idea.
