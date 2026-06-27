// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title IERC20
 * @notice Interface describing the minimum functionality
 *         required for an ERC20 token.
 *
 * @dev Interfaces only declare functions.
 *      They do not contain any implementation.
 */
interface IERC20 {
    /**
     * @notice Transfers tokens to another address.
     * @param to Recipient address.
     * @param amount Number of tokens to transfer.
     */
    function transfer(
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @notice Transfers tokens on behalf of another user.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @notice Returns an account's balance.
     */
    function balanceOf(
        address account
    ) external view returns (uint256);
}
