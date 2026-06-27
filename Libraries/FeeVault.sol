// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./PercentageMath.sol";

/**
 * @title FeeVault
 *
 * @notice Demonstrates why libraries exist.
 *
 * @dev
 * This contract does not implement percentage calculations.
 * Instead, it reuses the PercentageMath library.
 */
contract FeeVault {
    using PercentageMath for uint256;

    uint256 public constant PLATFORM_FEE = 300; // 3%

    /**
     * @notice Calculates the platform fee.
     */
    function calculateFee(
        uint256 amount
    )
        external
        pure
        returns (uint256)
    {
        return amount.percentOf(PLATFORM_FEE);
    }

    /**
     * @notice Returns amount after deducting fee.
     */
    function amountAfterFee(
        uint256 amount
    )
        external
        pure
        returns (uint256)
    {
        return amount.subtractPercentage(PLATFORM_FEE);
    }

    /**
     * @notice Returns amount after adding a bonus.
     */
    function amountWithBonus(
        uint256 amount,
        uint256 bonus
    )
        external
        pure
        returns (uint256)
    {
        return amount.addPercentage(bonus);
    }
}
