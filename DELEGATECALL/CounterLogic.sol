// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title CounterLogic
 * @author Your Name
 *
 * @notice
 * This contract ONLY contains business logic.
 *
 * It does not permanently store the counter.
 *
 * When executed using delegatecall,
 * the storage belongs to the calling contract.
 */
contract CounterLogic {
    // IMPORTANT:
    // This variable MUST occupy storage slot 0.
    // The proxy must have the same storage layout.
    uint256 public counter;

    /**
     * @notice Increments the counter.
     */
    function increment() external {
        counter++;
    }

    /**
     * @notice Decrements the counter.
     */
    function decrement() external {
        counter--;
    }
}
