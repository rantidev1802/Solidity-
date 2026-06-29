# ERC20 — The Foundation of DeFi

> *"ERC20 didn't just standardize tokens. It standardized value on Ethereum."*

---

## What is ERC20?

ERC20 is the **first widely adopted token standard** on Ethereum. It defines a common interface that allows wallets, decentralized applications (dApps), exchanges, lending protocols, and other smart contracts to interact with fungible tokens in a predictable way.

Before ERC20, every token contract exposed different function names and behaviors. Every wallet or protocol had to write custom integration logic for each token.

ERC20 solved this by introducing **one universal language** for fungible assets.

Once a wallet understands ERC20, it automatically understands every ERC20 token.

---

# Why ERC20 Exists

Ethereum only understands:

- Accounts
- Ether (ETH)
- Smart Contracts
- Storage

Ethereum **does not understand tokens.**

Tokens are not a native feature of Ethereum.

Instead, every token is simply a smart contract maintaining its own internal ledger.

Without ERC20, imagine every project creating its own API.

```
Token A

send()

move()

coins()

-----------------------

Token B

transferCoin()

walletBalance()

approveTransfer()

-----------------------

Token C

dispatch()

funds()

allowUser()
```

Every wallet would need to integrate every token individually.

DEXs wouldn't scale.

Lending protocols wouldn't exist.

Wallets couldn't automatically support new assets.

ERC20 solved this interoperability problem.

---

# The Big Picture

```
                    Ethereum

                        │

                Smart Contracts

                        │

                 ERC20 Standard

                        │

      ┌──────────┬──────────┬──────────┐

      │          │          │

    USDC       DAI        LINK

      │          │          │

      └──────────┴──────────┘

           Same Interface
```

Every token has different economics.

Every token has different use cases.

But they all expose the same interface.

That is the power of standards.

---

# Why ERC20 Changed Ethereum Forever

ERC20 introduced something much more important than tokens.

It introduced **composability**.

Instead of every protocol inventing a new way to transfer assets, everyone agreed to use the same building blocks.

This allowed developers to build protocols that work with **every future ERC20 token without modification.**

This idea became the foundation of DeFi.

```
                    ERC20

                       │

        ┌──────────────┼──────────────┐

        │              │              │

     Uniswap        Aave         Compound

        │              │              │

      Swaps        Lending      Borrowing

                       │

                 ERC4626 Vaults

                       │

               Entire DeFi Ecosystem
```

Almost every DeFi protocol ultimately relies on ERC20.

---

# Mental Model

Think of ERC20 as a **programmable accounting system**.

It doesn't store coins.

It stores numbers.

```
                 ERC20 Contract

        mapping(address => uint256)

                 balances

Alice --------------------► 500

Bob ----------------------► 100

Charlie ------------------► 900
```

Ownership is nothing more than numbers stored inside contract storage.

Moving tokens simply updates those numbers.

---

# ERC20 Architecture

ERC20 maintains two independent ledgers.

```
                        ERC20

                           │

          ┌────────────────┴────────────────┐

          │                                 │

    Ownership Ledger                 Permission Ledger

       balances                      allowances

          │                                 │

  "Who owns tokens?"             "Who may spend them?"

          │                                 │

      transfer()                      approve()

                                            │

                                      allowance()

                                            │

                                     transferFrom()
```

Everything in DeFi builds upon these two ledgers.

---

# Core Functions

## totalSupply()

Returns the total number of tokens currently in existence.

```
Total Supply

↓

1,000,000 Tokens
```

This value only changes during minting or burning.

Transfers never modify total supply.

---

## balanceOf(address)

Returns the token balance owned by an address.

```
balanceOf(Alice)

↓

500 Tokens
```

This is simply a lookup into the balances mapping.

---

## transfer(address,uint256)

Transfers tokens owned by the caller.

```
Alice

transfer(100)

↓

Bob
```

Requirements:

- Caller owns enough tokens
- Sender's balance decreases
- Receiver's balance increases
- Transfer event is emitted

---

## approve(address,uint256)

Delegates spending permission to another address.

```
Alice

↓

approve(Uniswap,1000)
```

Important:

**No tokens move.**

Only permission changes.

---

## allowance(owner,spender)

Returns how many tokens a spender is still allowed to spend.

```
Alice

↓

Uniswap

↓

1000 Tokens Remaining
```

---

## transferFrom()

Transfers tokens **on behalf of someone else**.

This is the function that powers almost every DeFi protocol.

```
Alice

↓

approve(Uniswap)

↓

Uniswap

↓

transferFrom()

↓

Liquidity Pool
```

Without `transferFrom()`, decentralized exchanges, lending protocols, vaults, and staking contracts could not exist.

---

# Why approve() Exists

Many beginners ask:

> Why doesn't Uniswap simply call transfer()?

Because **transfer() only moves the caller's own tokens.**

Uniswap does not own Alice's tokens.

Only Alice does.

ERC20 therefore introduces delegated spending.

Alice explicitly grants permission first.

```
Alice

│

approve()

▼

Allowance Created

│

transferFrom()

▼

Protocol Receives Tokens
```

Permission and ownership remain separate.

This is one of ERC20's most important design decisions.

---

# Events

ERC20 defines two required events.

## Transfer

```
Transfer(
from,
to,
amount
)
```

Emitted whenever tokens move.

Used by:

- MetaMask
- Etherscan
- Dune
- The Graph
- Portfolio trackers

---

## Approval

```
Approval(
owner,
spender,
amount
)
```

Emitted whenever spending permission changes.

Allows wallets and dashboards to display active approvals.

---

# Storage vs Events

A common misconception is that events store balances.

They do not.

```
Storage

↓

Current Truth

--------------------

Events

↓

Historical Record
```

Storage answers:

> Who owns tokens right now?

Events answer:

> What happened over time?

Contracts read storage.

Off-chain applications read events.

---

# Important Invariants

Every correct ERC20 implementation must preserve these properties.

```
✓ Sum(balances) == totalSupply

✓ transfer() never changes totalSupply

✓ Only owners or approved spenders can move tokens

✓ Balances never become negative

✓ Mint increases supply

✓ Burn decreases supply
```

Professional auditors think in invariants rather than individual functions.

---

# Why Wallets Automatically Support New Tokens

Wallets do not know anything about USDC, LINK, UNI, or AAVE.

They simply call the ERC20 interface.

```
balanceOf()

symbol()

name()

decimals()
```

If every token implements the same interface,

every wallet automatically works.

This is the power of standards.

---

# How ERC20 Connects to Future Standards

Understanding ERC20 unlocks the rest of Ethereum.

```
                    ERC20

                       │

          ┌────────────┼─────────────┐

          │            │             │

      ERC721      ERC1155      ERC2612

          │            │             │

        NFTs     Multi Assets     Permit

                                      │

                                   EIP712

                                      │

                               Typed Signatures

                                      │

                                  EIP1271

                              Smart Wallets

                                      │

                                   ERC4626

                                 Yield Vaults
```

Every future standard builds upon ideas first introduced by ERC20.

---

# Real-World Applications

ERC20 is the accounting layer behind:

- Stablecoins
- Decentralized Exchanges
- Lending Markets
- Borrowing Protocols
- Yield Vaults
- Liquidity Pools
- Governance Tokens
- Staking Protocols
- Token Bridges
- Flash Loans
- Real World Assets (RWAs)

If value moves on Ethereum, there is a high probability that ERC20 is involved.

---

# Key Takeaways

- Ethereum does not natively understand tokens.
- ERC20 is a smart contract standard, not a protocol rule.
- Tokens are simply balances stored in contract storage.
- ERC20 introduced a universal interface for fungible assets.
- `approve()` separates ownership from delegated authority.
- `transferFrom()` is the primitive that enables DeFi.
- Events allow wallets and explorers to observe token activity.
- Security depends on maintaining invariants.
- ERC20's simplicity enabled an entire financial ecosystem to emerge.

---

# Next Module

➡ **ERC721 — Non-Fungible Tokens**

ERC20 answers:

> **"How do we represent identical assets?"**

ERC721 answers:

> **"How do we represent unique assets?"**
