// contracts/N3RDy.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;

// Import ERC721 from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract N3RDy is ERC721 {
    constructor() ERC721("N3RDy", "N3RDy") {}
}
