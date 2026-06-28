// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title Proxy
 * @author Your Name
 *
 * @notice
 * Demonstrates the core idea behind delegatecall.
 *
 * This contract owns the storage.
 *
 * The logic contract owns the code.
 */
contract Proxy {
    // -----------------------------
    // IMPORTANT
    // -----------------------------
    //
    // Storage layout MUST match the
    // implementation contract.
    //
    // Slot 0
    //
    uint256 public counter;

    /// Address of the logic contract.
    address public immutable implementation;

    constructor(address logic) {
        implementation = logic;
    }

    /**
     * @notice Executes increment()
     * inside the logic contract.
     *
     * Storage changes happen inside
     * THIS contract.
     */
    function increment() external {
        (bool success,) = implementation.delegatecall(
            abi.encodeWithSignature("increment()")
        );

        require(success, "Delegatecall failed");
    }

    /**
     * @notice Executes decrement()
     * inside the logic contract.
     */
    function decrement() external {
        (bool success,) = implementation.delegatecall(
            abi.encodeWithSignature("decrement()")
        );

        require(success, "Delegatecall failed");
    }
}
