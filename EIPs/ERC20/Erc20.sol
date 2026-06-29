// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Production ERC20 Token
 * @dev Implementation of the ERC20 standard from scratch with custom errors.
 */
contract ProductionToken {
    // --- State Variables ---
    string public name;
    string public symbol;
    uint8 public immutable decimals;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // --- Events ---
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // --- Custom Errors ---
    error ZeroAddressDetected();
    error InsufficientBalance(uint256 available, uint256 required);
    error InsufficientAllowance(uint256 available, uint256 required);

    // --- Constructor ---
    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // --- Core ERC20 Functions ---

    function transfer(address to, uint256 amount) external returns (bool) {
        if (to == address(0)) revert ZeroAddressDetected();
        
        uint256 balanceFrom = balanceOf[msg.sender];
        if (balanceFrom < amount) revert InsufficientBalance(balanceFrom, amount);

        unchecked {
            balanceOf[msg.sender] = balanceFrom - amount;
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        if (spender == address(0)) revert ZeroAddressDetected();

        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        if (to == address(0)) revert ZeroAddressDetected();

        uint256 allowed = allowance[from][msg.sender];
        if (allowed != type(uint256).max) {
            if (allowed < amount) revert InsufficientAllowance(allowed, amount);
            unchecked {
                allowance[from][msg.sender] = allowed - amount;
            }
        }

        uint256 balanceFrom = balanceOf[from];
        if (balanceFrom < amount) revert InsufficientBalance(balanceFrom, amount);

        unchecked {
            balanceOf[from] = balanceFrom - amount;
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);
        return true;
    }

    // --- Mint & Burn Functions (Internal/Owner Controlled in Real Production) ---

    function mint(address to, uint256 amount) external {
        if (to == address(0)) revert ZeroAddressDetected();

        totalSupply += amount;
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) external {
        if (from == address(0)) revert ZeroAddressDetected();

        uint256 balanceFrom = balanceOf[from];
        if (balanceFrom < amount) revert InsufficientBalance(balanceFrom, amount);

        unchecked {
            balanceOf[from] = balanceFrom - amount;
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
