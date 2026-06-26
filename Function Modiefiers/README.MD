# 🔐 Function Modifiers in Solidity

> "Write the validation once. Reuse it everywhere."

Function modifiers are one of Solidity's most powerful language features. They allow developers to **inject reusable logic before and/or after a function executes**, eliminating repetitive code and improving readability.

Instead of writing the same `require()` statements inside every function, we can define a modifier once and apply it wherever needed.

---

# 🎯 Why do Function Modifiers Exist?

Imagine a contract with multiple functions that should only be callable by the owner.

Without modifiers:

```solidity
function pause() public {
    require(msg.sender == owner, "Not Owner");
    ...
}

function withdraw() public {
    require(msg.sender == owner, "Not Owner");
    ...
}

function updatePrice() public {
    require(msg.sender == owner, "Not Owner");
    ...
}
```

The same validation is repeated in every function.

This violates the **DRY (Don't Repeat Yourself)** principle.

Modifiers solve this problem.

---

# ✅ Using a Modifier

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not Owner");
    _;
}
```

Now every protected function becomes much cleaner.

```solidity
function withdraw() public onlyOwner {
    ...
}

function pause() public onlyOwner {
    ...
}

function updatePrice() public onlyOwner {
    ...
}
```

The validation is written once and reused everywhere.

---

# 🧠 How Modifiers Work

Think of a modifier as a wrapper around a function.

```
User Calls Function
        │
        ▼
 Modifier Executes
        │
        ▼
 Validation Logic
        │
   Condition True?
   ┌───────────────┐
   │               │
 Yes              No
 │                 │
 ▼                 ▼
Run Function     Revert
```

The modifier decides whether the function body should execute.

---

# ⭐ The Special Meaning of `_`

The underscore (`_`) is the most important part of every modifier.

It acts as a **placeholder** where Solidity inserts the function body.

Example:

```solidity
modifier onlyOwner {
    require(msg.sender == owner);
    _;
}
```

Suppose we write:

```solidity
function withdraw() public onlyOwner {
    balance = 0;
}
```

The compiler internally treats it like this:

```solidity
require(msg.sender == owner);

balance = 0;
```

The `_` literally gets replaced by the function body.

---

# 📍 Modifier Execution Order

Code before `_`

↓

Function Body

↓

Code after `_`

Example:

```solidity
modifier logExecution() {
    console.log("Before");
    _;
    console.log("After");
}
```

Applied to:

```solidity
function deposit() public logExecution {
    console.log("Inside");
}
```

Execution becomes

```
Before

↓

Inside

↓

After
```

---

# 🧩 Modifiers Can Execute Code After the Function

```solidity
modifier example() {
    beforeLogic();

    _;

    afterLogic();
}
```

This is commonly used for

- Unlocking mutexes
- Updating state
- Logging events
- Cleanup logic

---

# 🎯 Example: Reentrancy Guard

One of the most common modifiers in Solidity.

```solidity
bool locked;

modifier nonReentrant() {
    require(!locked, "Reentrant Call");

    locked = true;

    _;

    locked = false;
}
```

Execution Flow

```
User Calls withdraw()

↓

locked == false

↓

locked = true

↓

withdraw() executes

↓

locked = false

↓

Finish
```

If an attacker tries to call the function again before it finishes,

```
locked == true

↓

Transaction Reverts
```

This prevents **Reentrancy Attacks**.

---

# 📦 Modifiers with Parameters

Modifiers can accept arguments just like functions.

```solidity
modifier costs(uint price) {
    require(msg.value >= price);
    _;
}
```

Usage

```solidity
function register()
    public
    payable
    costs(1 ether)
{
}
```

The modifier receives

```
price = 1 ether
```

before the function executes.

---

# 🔗 Multiple Modifiers

A function can have multiple modifiers.

```solidity
function withdraw()
    public
    onlyOwner
    nonReentrant
{
}
```

Execution order is

```
onlyOwner

↓

nonReentrant

↓

withdraw()

↓

Finish nonReentrant

↓

Finish onlyOwner
```

Modifiers execute **from left to right**.

---

# ⚠️ Important Notes

### A modifier can stop execution completely

```solidity
modifier onlyOwner {
    require(msg.sender == owner);
    _;
}
```

If the `require()` fails,

the function body is **never executed**.

---

### A modifier cannot magically access function variables

It only knows what you explicitly pass to it.

```solidity
modifier minimumAmount(uint amount) {
    require(amount > 0);
    _;
}
```

Usage

```solidity
function deposit(uint amount)
    public
    minimumAmount(amount)
{
}
```

---

# 🌍 Real-World Modifiers

OpenZeppelin's `Ownable`

```solidity
onlyOwner
```

OpenZeppelin's `Pausable`

```solidity
whenNotPaused
```

OpenZeppelin's `ReentrancyGuard`

```solidity
nonReentrant
```

Aave

```
onlyPoolAdmin
```

Compound

```
onlyAdmin
```

These protocols rely heavily on modifiers to enforce permissions and security.

---

# 📚 Common Use Cases

✅ Access Control

```solidity
onlyOwner
```

---

✅ Minimum Payment

```solidity
costs(1 ether)
```

---

✅ Reentrancy Protection

```solidity
nonReentrant
```

---

✅ Emergency Pause

```solidity
whenNotPaused
```

---

✅ Input Validation

```solidity
validAddress(user)
```

---

# 💡 What I Learned

- Modifiers are reusable wrappers around functions.
- The `_` symbol represents the function body.
- Code before `_` executes before the function.
- Code after `_` executes after the function.
- Multiple modifiers execute from left to right.
- Modifiers improve readability, reduce duplication, and make contracts easier to maintain.
- Security libraries like OpenZeppelin use modifiers extensively for access control, pausing, and reentrancy protection.

---

# 📖 References

- Solidity Documentation
- OpenZeppelin Contracts
- Ethereum Yellow Paper (Execution Model)
