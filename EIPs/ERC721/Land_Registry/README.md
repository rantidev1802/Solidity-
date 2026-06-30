# 🏡 Digital Land Registry

A blockchain-based land registry built on the ERC-721 standard, where each NFT represents a unique land title issued by a trusted government authority.

---

# Overview

The Digital Land Registry is a proof-of-concept that demonstrates how **real-world land ownership** can be represented on-chain using the ERC-721 standard.

Each registered property is issued as a unique NFT. The NFT manages ownership, while the registry stores the corresponding land information such as survey number, city, area, and metadata URI. Together, they form a digital representation of a land title.

---

# Problem Statement

Traditional land registries rely on centralized record keeping, making ownership verification and record management dependent on trusted authorities.

This project explores how blockchain can provide a transparent, tamper-resistant, and standardized representation of land ownership.

---

# Proposed Solution

The registry models the **Government** as the trusted authority responsible for issuing land titles.

Whenever a property is registered:

* A unique ERC-721 NFT is minted.
* The NFT is assigned to the owner.
* A unique `tokenId` identifies the land parcel.
* The `tokenId` is linked to the corresponding land record.

Ownership is managed through ERC-721, while land-specific information is maintained separately by the registry.

---

# Why ERC-721?

Land naturally fits the ERC-721 ownership model because every property is:

* Unique
* Owned by a single entity at a time
* Individually transferable
* Permanently identifiable

Instead of creating a custom ownership system, the registry builds upon the standardized and battle-tested ERC-721 interface.

---

# System Architecture

```text
                    Government
                (Registry Admin)
                        │
                        │ Registers Land
                        ▼
         +----------------------------------+
         |     DigitalLandRegistry          |
         |----------------------------------|
         | ERC721 Ownership                 |
         | Land Metadata Storage            |
         | Access Control                   |
         +----------------------------------+
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
     ERC721 Ownership     Land Metadata
      ownerOf()           Survey Number
      Transfers           City
      Approvals           Area (Sq.Ft.)
                           Metadata URI
```

---

# Mental Model

Imagine a physical government land office.

Every registered property receives a **physical title deed**.

This project replaces that paper title with an ERC-721 NFT.

```text
Physical Property
        │
        ▼
Government Registration
        │
        ▼
ERC721 NFT
(tokenId)
        │
        ▼
Land Record
```

The NFT represents **who owns the property**.

The land record represents **what the property is**.

Together they form a complete digital title.

---

# Data Flow

```text
Government
      │
      ▼
registerLand()
      │
      ▼
Generate tokenId
      │
      ▼
Store Land Metadata
      │
      ▼
Mint ERC721 NFT
      │
      ▼
Assign Ownership
      │
      ▼
Emit Registration Event
```

Once registered,

```text
tokenId
      │
      ├────────────► ownerOf(tokenId)
      │
      └────────────► Land Details
```

The same identifier is used to retrieve both ownership and property information.

---

# Storage Design

The registry maintains two independent layers.

### Ownership Layer

Inherited from ERC-721.

```text
tokenId
      │
      ▼
Owner
```

Responsible only for ownership management.

---

### Metadata Layer

Implemented by the registry.

```text
tokenId
      │
      ▼
Land

├── Survey Number
├── City
├── Area
└── Metadata URI
```

Responsible for describing the registered property.

---

# Registration Workflow

Every land registration follows the same lifecycle.

```text
Validate Input
      │
      ▼
Generate Unique Token ID
      │
      ▼
Persist Land Record
      │
      ▼
Mint ERC721 Token
      │
      ▼
Assign Initial Owner
      │
      ▼
Emit LandRegistered Event
```

---

# Contract Responsibilities

## Registry Administrator

* Registers new land parcels.
* Issues land titles.
* Controls the creation of new registry records.

---

# Public Interface

## `registerLand()`

Registers a new land parcel, stores its metadata, mints a unique ERC-721 token, and assigns ownership to the specified address.

---

## `getLandDetails()`

Retrieves the complete property record associated with a given `tokenId`, including ownership and land metadata.

---

# Inherited ERC-721 Functions

| Function              | Description                                                                  |
| --------------------- | ---------------------------------------------------------------------------- |
| `ownerOf()`           | Returns the current owner of a land title.                                   |
| `balanceOf()`         | Returns the total number of land titles owned by an address.                 |
| `safeTransferFrom()`  | Securely transfers ownership while verifying the recipient can receive NFTs. |
| `transferFrom()`      | Transfers ownership without performing recipient safety checks.              |
| `approve()`           | Grants permission to transfer a specific land title.                         |
| `setApprovalForAll()` | Grants permission to manage all land titles owned by an address.             |
| `tokenURI()`          | Returns the metadata URI associated with a land title.                       |
