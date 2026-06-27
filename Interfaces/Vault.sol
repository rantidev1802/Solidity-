// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./IERC20.sol";

/**
 * @title Vault
 * @notice Demonstrates why interfaces exist.
 *
 * @dev The vault does not know how the token works internally.
 *      It only knows that the token follows the IERC20 interface.
 */
contract Vault {
    IERC20 private immutable i_token;

    constructor(address tokenAddress) {
        // Store the token contract as an IERC20.
        i_token = IERC20(tokenAddress);
    }

    /**
     * @notice Deposits tokens into the vault.
     */
    function deposit(uint256 amount) external {
        i_token.transferFrom(
            msg.sender,
            address(this),
            amount
        );
    }

    /**
     * @notice Sends tokens from the vault.
     */
    function withdraw(uint256 amount) external {
        i_token.transfer(msg.sender, amount);
    }

    /**
     * @notice Returns the vault's token balance.
     */
    function vaultBalance()
        external
        view
        returns (uint256)
    {
        return i_token.balanceOf(address(this));
    }
}
