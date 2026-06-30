// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; // Fixed compiler version for deterministic production builds

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DigitalLandRegistry
 * @dev Practical, gas-optimized registry for tokenizing land parcels as NFTs.
 */
contract DigitalLandRegistry is ERC721URIStorage, Ownable {

    // --- Custom Errors (Gas-efficient alternative to require strings) ---
    error LandRegistry__ZeroAddress();
    error LandRegistry__InvalidLandDetails();
    error LandRegistry__TokenDoesNotExist();

    // --- Structs ---
    struct Land {
        string surveyNumber;
        string city;
        uint256 areaSqFt;
    }

    // --- State Variables ---
    // Combined counter and ID generation. Starts at 0 naturally.
    uint256 public nextTokenId;

    // Mapping from Token ID to Land structural data
    mapping(uint256 => Land) private s_lands;

    // --- Events ---
    event LandRegistered(
        uint256 indexed tokenId, 
        address indexed owner, 
        string surveyNumber, 
        string city
    );

    constructor()
        ERC721("Digital Land Registry", "LAND")
        Ownable(msg.sender)
    {}

    /**
     * @notice Registers a new piece of land and mints an NFT to the designated owner.
     * @dev Only callable by the contract owner (Registry admin).
     */
    function registerLand(
        address owner,
        string calldata surveyNumber, // Changed from memory to calldata for gas savings
        string calldata city,         // Changed from memory to calldata for gas savings
        uint256 areaSqFt,
        string calldata uri           // Changed from memory to calldata for gas savings
    ) external onlyOwner {
        // Input Validations
        if (owner == address(0)) revert LandRegistry__ZeroAddress();
        if (bytes(surveyNumber).length == 0 || bytes(city).length == 0 || areaSqFt == 0) {
            revert LandRegistry__InvalidLandDetails();
        }

        // Cache the current ID to save gas, then increment immediately
        uint256 tokenId = nextTokenId;
        unchecked {
            nextTokenId++; // Safe from overflow in standard realistic timelines
        }

        // Direct storage assignment (slight gas optimization over Struct initializing layout)
        Land storage newLand = s_lands[tokenId];
        newLand.surveyNumber = surveyNumber;
        newLand.city = city;
        newLand.areaSqFt = areaSqFt;

        // Mint and set URI
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, uri);

        emit LandRegistered(tokenId, owner, surveyNumber, city);
    }

    /**
     * @notice Retrieves full architectural and ownership data of a specific land parcel.
     * @param tokenId The ID of the land NFT.
     */
    function getLandDetails(uint256 tokenId)
        external
        view
        returns (
            string memory surveyNumber,
            string memory city,
            uint256 areaSqFt,
            string memory uri,
            address owner
        )
    {
        // Use OpenZeppelin's internal owner tracking or fallback to ensure it exists
        address landOwner = _ownerOf(tokenId);
        if (landOwner == address(0)) revert LandRegistry__TokenDoesNotExist();

        // Read directly from storage pointer to memory
        Land storage land = s_lands[tokenId];

        return (
            land.surveyNumber,
            land.city,
            land.areaSqFt,
            tokenURI(tokenId),
            landOwner
        );
    }
}
