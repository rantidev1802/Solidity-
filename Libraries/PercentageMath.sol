// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title PercentageMath
 * @author Your Name
 *
 * @notice A reusable library for percentage calculations.
 *
 * @dev
 * Libraries contain IMPLEMENTATION.
 * They are used to avoid writing the same logic
 * in multiple contracts.
 */
library PercentageMath {
    uint256 internal constant PRECISION = 10_000; // 10000 = 100%

    /**
     * @notice Calculates a percentage of a number.
     *
     * Example:
     * amount = 1000
     * percentage = 500
     *
     * returns 50
     *
     * because
     * 500 = 5%
     */
    function percentOf(
        uint256 amount,
        uint256 percentage
    ) internal pure returns (uint256) {
        return (amount * percentage) / PRECISION;
    }

    /**
     * @notice Adds a percentage onto a number.
     *
     * Example:
     *
     * 100 + 5% = 105
     */
    function addPercentage(
        uint256 amount,
        uint256 percentage
    ) internal pure returns (uint256) {
        return amount + percentOf(amount, percentage);
    }

    /**
     * @notice Subtracts a percentage from a number.
     *
     * Example:
     *
     * 100 - 5% = 95
     */
    function subtractPercentage(
        uint256 amount,
        uint256 percentage
    ) internal pure returns (uint256) {
        return amount - percentOf(amount, percentage);
    }
}
