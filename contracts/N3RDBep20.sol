// contracts/N3RD.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.7.3;

// Import Ownable from the OpenZeppelin Contracts library
import "@openzeppelin/contracts/GSN/GSNRecipient.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract N3RDBep20 is {
    // Create a new role identifier for the minter role
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor(address minter, address burner) ERC20("N3RD", "N3RD") {
        _setupRole(MINTER_ROLE, minter);
        _setupRole(BURNER_ROLE, burner);

        // Grant the contract deployer the default admin role: it will be able
        // to grant and revoke any roles
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public {
        // Check that the calling account has the minter role
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _burn(from, amount);
    }
}
