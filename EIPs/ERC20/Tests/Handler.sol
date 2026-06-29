// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ProductionToken} from "../src/ProductionToken.sol";

contract TokenHandler is Test {
    ProductionToken public token;
    
    // Track unique users dynamically to sum balances later
    address[] public users;
    mapping(address => bool) private isUser;

    constructor(ProductionToken _token) {
        token = _token;
    }

    function mint(uint256 userIndex, uint256 amount) public {
        // Limit amount to prevent extreme overflow limits during test iterations
        amount = bound(amount, 0, 1e28); 
        address user = _getUser(userIndex);
        token.mint(user, amount);
    }

    function burn(uint256 userIndex, uint256 amount) public {
        address user = _getUser(userIndex);
        uint256 bal = token.balanceOf(user);
        amount = bound(amount, 0, bal);
        if (bal > 0) {
            token.burn(user, amount);
        }
    }

    function transfer(uint256 fromIndex, uint256 toIndex, uint256 amount) public {
        address from = _getUser(fromIndex);
        address to = _getUser(toIndex);
        if (to == address(0)) to = address(0x123); // Prevent zero address revert

        uint256 bal = token.balanceOf(from);
        amount = bound(amount, 0, bal);

        if (bal > 0 && from != to) {
            vm.prank(from);
            token.transfer(to, amount);
        }
    }

    function getUsers() public view returns (address[] memory) {
        return users;
    }

    function _getUser(uint256 index) internal returns (address) {
        // Pick from 5 stable deterministic addresses
        address user = address(uint160(bound(index, 1, 5)));
        if (!isUser[user]) {
            isUser[user] = true;
            users.push(user);
        }
        return user;
    }
}
