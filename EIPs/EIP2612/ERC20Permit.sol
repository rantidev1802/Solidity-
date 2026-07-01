// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title ExplanatoryPermitToken
 * @dev Custom implementation of EIP-2612 to showcase signature mechanics.
 */
contract ExplanatoryPermitToken is ERC20 {
    
    // Mapping to track account nonces to prevent replay attacks
    mapping(address => uint256) public nonces;

    // EIP-712 Domain Separator - unique fingerprint for this contract on this network
    bytes32 public immutable DOMAIN_SEPARATOR;

    // Keccak256 hash of the EIP-712 Domain struct type
    bytes32 public constant DOMAIN_TYPEHASH = 
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    // Keccak256 hash of the Permit function schema struct type
    bytes32 public constant PERMIT_TYPEHASH = 
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply * 10 ** decimals());

        // Calculate the EIP-712 Domain Separator at deployment
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes("1")), // Version
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @notice Allows a spender to change their allowance using an off-chain ECDSA signature.
     * @param owner The token owner who signed the message.
     * @param spender The address authorized to spend the tokens.
     * @param value The amount of tokens authorized.
     * @param deadline A timestamp in the future after which the signature expires.
     * @param v Recovery id (part of the signature)
     * @param r Part of the ECDSA signature output
     * @param s Part of the ECDSA signature output
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        // 1. Enforce deadline safety check
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        // 2. Recreate the packed struct hash of the permit parameters (EIP-712)
        bytes32 structHash = keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                owner,
                spender,
                value,
                nonces[owner], // Protects against reusing this exact signature
                deadline
            )
        );

        // 3. Assemble the final Ethereum Signed Typed Data digest
        bytes32 hash = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash)
        );

        // 4. Cryptographically recover the signer address using ecrecover
        address signer = ecrecover(hash, v, r, s);
        
        // 5. Ensure the signature is valid and belongs to the actual token owner
        require(signer != address(0) && signer == owner, "ERC20Permit: invalid signature");

        // 6. Increment the user's nonce to completely invalidate this signature for future use
        nonces[owner]++;

        // 7. Grant the allowance safely
        _approve(owner, spender, value);
    }
}
