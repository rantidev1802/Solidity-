// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ProductionToken} from "../src/ProductionToken.sol";

contract ProductionTokenTest is Test {
    ProductionToken public token;
    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        token = new ProductionToken("Production Token", "PROD", 18);
    }

    // --- Unit Tests ---

    function test_Metadata() public view {
        assertEq(token.name(), "Production Token");
        assertEq(token.symbol(), "PROD");
        assertEq(token.decimals(), 18);
    }

    function test_MintAndBurn() public {
        token.mint(alice, 1000);
        assertEq(token.balanceOf(alice), 1000);
        assertEq(token.totalSupply(), 1000);

        token.burn(alice, 400);
        assertEq(token.balanceOf(alice), 600);
        assertEq(token.totalSupply(), 600);
    }

    function test_Revert_InsufficientBalance() public {
        token.mint(alice, 100);
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(ProductionToken.InsufficientBalance.selector, 100, 150));
        token.transfer(bob, 150);
    }

    // --- Fuzz Tests ---

    function testFuzz_Mint(address to, uint256 amount) public {
        // Assume to prevent the zero address revert
        vm.assume(to != address(0));
        
        uint256 preSupply = token.totalSupply();
        token.mint(to, amount);
        
        assertEq(token.balanceOf(to), amount);
        assertEq(token.totalSupply(), preSupply + amount);
    }

    function testFuzz_Transfer(uint256 mintAmount, uint256 transferAmount) public {
        // Avoid overflow issues during mint and ensure valid transfer bounds
        vm.assume(mintAmount >= transferAmount);
        
        token.mint(alice, mintAmount);
        
        vm.prank(alice);
        token.transfer(bob, transferAmount);
        
        assertEq(token.balanceOf(alice), mintAmount - transferAmount);
        assertEq(token.balanceOf(bob), transferAmount);
    }
}
