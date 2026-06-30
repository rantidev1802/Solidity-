# Contract Interface

The `DigitalLandRegistry` contract exposes a minimal interface for registering, managing, and verifying ownership of tokenized land parcels. Rather than implementing a custom ownership mechanism, the registry extends the ERC-721 standard, allowing ownership management to remain standardized while storing land-specific information within the registry.

---

## `constructor()`

Initializes the registry by deploying an ERC-721 collection under the name **Digital Land Registry (LAND)** and assigning the deploying account as the registry administrator.

The administrator acts as the trusted authority responsible for issuing new land titles through the registry.

---

## `registerLand()`

Registers a new land parcel within the registry.

The function mints a unique ERC-721 token representing the land title, associates it with the designated owner, persists the corresponding land metadata, and links the asset to its metadata URI.

Before registration, the contract validates the supplied owner address and land attributes to ensure only valid records are stored on-chain.

Upon successful execution, a `LandRegistered` event is emitted to provide an immutable audit trail of the registration.

**Responsibilities**

* Registers a new land parcel.
* Mints a unique land title (NFT).
* Stores the land metadata.
* Associates off-chain metadata via URI.
* Emits an auditable registration event.

**Access**

* Restricted to the Registry Administrator (`onlyOwner`).

---

## `getLandDetails()`

Retrieves the complete registry record associated with a given land title.

The function verifies that the requested asset exists before returning its metadata together with the current ownership information maintained by the ERC-721 implementation.

**Returns**

* Survey Number
* City
* Area (Sq. Ft.)
* Metadata URI
* Current Owner

This function serves as the primary read interface for querying registered land assets.

---

# ERC-721 Interface

Ownership and transfer mechanics are delegated entirely to the OpenZeppelin ERC-721 implementation, ensuring compliance with the ERC-721 specification and interoperability with supporting infrastructure.

---

## `ownerOf()`

Returns the current owner of a registered land title.

Ownership information is maintained by the ERC-721 standard and represents the authoritative owner of the corresponding land NFT.

---

## `balanceOf()`

Returns the total number of registered land titles owned by a given address.

---

## `safeTransferFrom()`

Transfers ownership of a land title while verifying that recipient smart contracts implement the ERC-721 receiver interface.

This is the recommended transfer mechanism for preserving asset safety during ownership transfers.

---

## `transferFrom()`

Transfers ownership without performing recipient compatibility checks.

Provided for ERC-721 compatibility and interoperability.

---

## `approve()`

Authorizes a third party to transfer ownership of a specific land title on behalf of its current owner.

---

## `setApprovalForAll()`

Authorizes or revokes an operator's ability to manage all land titles owned by the caller.

---

## `tokenURI()`

Returns the metadata URI associated with a registered land title.

The metadata may reference property documents, cadastral information, maps, or any additional off-chain resources describing the asset.

---

# Events

## `LandRegistered`

Emitted whenever a new land parcel is successfully registered within the registry.

The event records:

* Registered `tokenId`
* Assigned owner
* Survey number
* City

This event provides an immutable and indexable record of every land registration, enabling external applications and indexing services to monitor registry activity efficiently.

