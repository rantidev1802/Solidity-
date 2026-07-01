# ERC-2612 — Permit (Signature-based Approvals for ERC-20)

## Overview

ERC-2612 extends the ERC-20 standard by introducing **`permit()`**, a mechanism that allows token approvals to be authorized using **off-chain cryptographic signatures** instead of requiring an on-chain `approve()` transaction.

It does **not** replace ERC-20 or change the transfer mechanism. Instead, it modernizes how **allowances are created**, enabling smoother interactions with DeFi protocols while preserving the existing ERC-20 security model.

---

# Motivation

ERC-20 introduced delegated spending through the `approve()` and `transferFrom()` model.

Before ERC-2612, a user interacting with a protocol for the first time had to perform two separate blockchain transactions:

```
approve()

↓

swap / deposit / stake
```

This resulted in:

* Two wallet confirmations
* Two blockchain transactions
* Two gas payments
* Slower onboarding
* Poor UX for DeFi applications

The protocol only needed **permission to spend tokens**, yet users had to submit an entire transaction just to grant that permission.

ERC-2612 solves this by replacing the approval transaction with a signed authorization message.

---

# What Problem Does It Solve?

Instead of creating an allowance by executing `approve()`, the owner signs a permission off-chain.

That signed permission is later submitted to the blockchain through `permit()`, where the token contract verifies the signature before updating the allowance.

Traditional ERC-20:

```
Owner

↓

approve()

↓

Allowance Created
```

ERC-2612:

```
Owner

↓

Signs Permit

↓

permit()

↓

Allowance Created
```

The allowance system remains unchanged.

Only the authorization mechanism changes.

---

# Permit Architecture

```
                 Off-chain
┌──────────────────────────────────┐
│                                  │
│  User Wallet (MetaMask)          │
│                                  │
│  Creates EIP-712 Message         │
│          │                       │
│          ▼                       │
│ Signs with Private Key           │
│          │                       │
│          ▼                       │
│ Generates Digital Signature      │
└──────────┬───────────────────────┘
           │
           │ Signature
           ▼
                On-chain

permit(owner, spender, value, deadline, signature)

           │
           ▼

Verify Signature

↓

Verify Nonce

↓

Verify Deadline

↓

Update Allowance

↓

Increment Nonce
```

Unlike `approve()`, the token owner does **not** submit the transaction.

Anyone can submit the signed permit because the authorization comes from the cryptographic signature—not from `msg.sender`.

---

# How `permit()` Works

A permit contains:

* Owner
* Spender
* Amount
* Nonce
* Deadline

The wallet signs this structured data using the owner's private key.

When `permit()` is called, the token contract:

1. Reconstructs the signed message.
2. Computes its EIP-712 hash.
3. Recovers the signer using `ecrecover()`.
4. Verifies the recovered address equals the owner.
5. Confirms the nonce is correct.
6. Checks the deadline has not expired.
7. Updates the allowance.
8. Increments the nonce.

Only after these validations does the approval become valid.

---

# Role of EIP-712

ERC-2612 depends on **EIP-712**, the Ethereum standard for signing **structured typed data**.

Instead of signing unreadable hashes, wallets display meaningful information before asking users to sign.

Example:

```
Permit

Owner:
Alice

Spender:
Uniswap Router

Amount:
100 USDC

Deadline:
Tomorrow
```

This makes signatures:

* Human-readable
* Domain-specific
* Resistant to replay across contracts
* Much safer than signing arbitrary bytes

---

# Domain Separator

One of the most important components of ERC-2612 is the **DOMAIN_SEPARATOR**.

Think of it as a unique identity card for the contract.

It binds every signature to:

* Token Contract
* Token Name
* Version
* Chain ID

Without it, a signature intended for one token could potentially be replayed against another contract or even another blockchain.

**Mental Model**

```
Passport

↓

Only valid for one country
```

Similarly,

```
Permit Signature

↓

Only valid for one token contract
```

---

# Nonce

Every account maintains an ever-increasing nonce.

```
Nonce = 0

↓

Permit Used

↓

Nonce = 1
```

Every signed permit contains the current nonce.

Once the permit succeeds, the nonce increments automatically.

This ensures that **every signature is valid only once**.

---

# Replay Attack

Imagine Alice signs:

```
Approve 100 USDC
```

Without nonces:

```
Attacker

↓

Uses Signature

↓

Uses Same Signature Again

↓

Uses It Forever
```

The contract cannot distinguish between a new approval and an old one.

This is known as a **Replay Attack**.

By including the nonce inside the signed message, every signature becomes single-use.

Once consumed, it can never be reused.

---

# `ecrecover()`

Ethereum never receives your private key.

Instead, MetaMask uses the private key to produce a digital signature.

During `permit()`, the contract uses Ethereum's built-in `ecrecover()` function to determine **which address created that signature**.

```
Message Hash

+

Signature

↓

ecrecover()

↓

Recovered Address
```

If the recovered address matches the owner, the permit is accepted.

Otherwise, the transaction reverts.

This is why **anyone can submit a permit**, yet only the owner can authorize it.

---

# Why "Gasless" Doesn't Mean Free

ERC-2612 is often described as enabling **gasless approvals**, but this does **not** mean blockchain transactions become free.

Creating the signature happens entirely off-chain and therefore costs no gas.

However, someone still needs to submit the transaction that executes `permit()`.

```
Traditional ERC-20

approve() → Gas

swap() → Gas

------------------------

ERC-2612

Sign Permit → No Gas

permit() + swap() → One Transaction → Gas
```

The gas cost is simply shifted to the transaction that executes the permit.

A relayer or protocol may even choose to pay that gas on behalf of the user.

---

# Permit2

ERC-2612 only works if the token contract implements `permit()`.

Many older ERC-20 tokens do not.

To solve this, Uniswap introduced **Permit2**.

Instead of every token implementing permit, Permit2 acts as a **universal permission manager**.

```
ERC-2612

Token A → permit()

Token B → permit()

Token C → permit()

----------------------------

Permit2

Token A

Token B

Token C

↓

Single Shared Permit Contract
```

Benefits of Permit2:

* Works with legacy ERC-20 tokens
* Standardized approval flow
* Time-limited approvals
* Fine-grained spending permissions
* Better wallet and protocol interoperability

It extends the idea of signature-based approvals beyond tokens that natively support ERC-2612.

---

# Security Considerations

ERC-2612 relies on cryptographic signatures, making correct implementation critical.

When implementing or auditing:

* Verify signatures using `ecrecover()`.
* Always validate the signer matches the owner.
* Reject expired permits.
* Increment the nonce after every successful permit.
* Prevent replay attacks through nonce validation.
* Correctly implement EIP-712 hashing.
* Include a proper `DOMAIN_SEPARATOR` containing the chain ID and contract address.
* Prefer audited implementations such as OpenZeppelin's `ERC20Permit` rather than implementing signature verification manually.

---

# Mental Model

Think of ERC-2612 as replacing an in-person approval with a digitally signed authorization letter.

**ERC-20**

```
Owner

↓

Visits Office

↓

Signs Approval Form

↓

Permission Recorded
```

**ERC-2612**

```
Owner

↓

Signs Authorization Letter

↓

Someone Else Delivers It

↓

Office Verifies Signature

↓

Permission Recorded
```

The office doesn't care who delivers the letter.

It only cares that **the signature belongs to the owner**.

---

# Key Takeaways

* ERC-2612 extends ERC-20 with signature-based approvals.
* `permit()` creates allowances without requiring an `approve()` transaction.
* It relies on EIP-712 for structured message signing.
* `ecrecover()` verifies who signed the permit.
* `DOMAIN_SEPARATOR` binds signatures to a specific contract and chain.
* Nonces prevent replay attacks by making every signature single-use.
* Deadlines limit how long a signature remains valid.
* `permit()` **does not transfer tokens**—it only updates allowances.
* Gasless approvals mean **signing is free**, not that blockchain transactions are free.
* Permit2 generalizes the concept by providing a universal approval system for many ERC-20 tokens, including those without native ERC-2612 support.




ERC-20
│
├── Ownership of fungible tokens
│
├── approve()
│      │
│      └── Delegation through an on-chain transaction
│
└── ERC-2612
       │
       └── Delegation through an off-chain cryptographic signature

                │

        Verified on-chain using:
        • EIP-712 (structured message format)
        • ECDSA (digital signatures)
        • ecrecover() (recover signer)
        • Nonces (prevent replay)
        • Deadlines (limit validity)
        • DOMAIN_SEPARATOR (bind to one contract and chain)
