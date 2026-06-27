// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./IERC20.sol";

/**
 * @title MockToken
 * @notice A very small token implementation.
 *
 * @dev This contract IMPLEMENTS the IERC20 interface.
 */
contract MockToken is IERC20 {
    mapping(address => uint256) private s_balances;

    constructor() {
        s_balances[msg.sender] = 1_000_000 ether;
    }

    function transfer(
        address to,
        uint256 amount
    ) external override returns (bool) {
        s_balances[msg.sender] -= amount;
        s_balances[to] += amount;

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        s_balances[from] -= amount;
        s_balances[to] += amount;

        return true;
    }

    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return s_balances[account];
    }
}
