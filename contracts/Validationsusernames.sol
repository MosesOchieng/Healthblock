// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;

// Import necessary interfaces and libraries for handling ERC20 tokens and SafeMath
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@ensdomains/ens-contracts/contracts/ENS.sol";
import "@ensdomains/ens-contracts/contracts/Registrar.sol";

contract SpruceID {
    using SafeMath for uint256;

    // Address of the ERC20 token used for premium payments
    address public tokenAddress;

    // Mapping to track verified user identities
    mapping(address => bool) public isIdentityVerified;

    // Mapping to store reserved usernames and their expiration timestamps
    mapping(bytes32 => uint256) public usernameExpiry;

    // ENS contract address
    ENS public ens;

    // Registrar contract address
    Registrar public registrar;

    // Event to notify when a user's identity is verified
    event IdentityVerified(address indexed user);

    constructor(
        address _tokenAddress,
        address _ensAddress,
        address _registrarAddress
    ) {
        tokenAddress = _tokenAddress;
        ens = ENS(_ensAddress);
        registrar = Registrar(_registrarAddress);
    }

    // Function for users to undergo identity verification by creating a Spruce ID
    function createSpruceID(string calldata _username) external {
        bytes32 node = keccak256(abi.encodePacked(_username));

        // Check if the username is available in ENS and not expired
        require(
            ens.owner(node) == address(0),
            "SpruceID: Username not available"
        );
        require(
            usernameExpiry[node] < block.timestamp,
            "SpruceID: Username already reserved"
        );

        // Reserve the username for the user with a one-year registration duration
        uint256 registrationDuration = 31536000;
        registrar.register(node, msg.sender, registrationDuration);
        // Set the username expiration timestamp
        usernameExpiry[node] = block.timestamp.add(registrationDuration);

        // Verify user identity
        // (Implement your identity verification logic here)
        bool isVerified = true;

        // Ensure the user's identity is verified
        require(isVerified, "SpruceID: Identity verification failed");

        // Update the user's identity verification status
        isIdentityVerified[msg.sender] = true;

        // Emit the IdentityVerified event
        emit IdentityVerified(msg.sender);
    }

    // Function to check if a user's identity is verified
    function isIdentityVerifiedForUser(
        address user
    ) external view returns (bool) {
        return isIdentityVerified[user];
    }

    // Function to renew the user's username for another registration duration
    function renewUsername(string calldata _username) external {
        bytes32 node = keccak256(abi.encodePacked(_username));

        // Check if the username is owned by the user and has expired
        require(
            ens.owner(node) == msg.sender,
            "SpruceID: You do not own this username"
        );
        require(
            usernameExpiry[node] < block.timestamp,
            "SpruceID: Username is not expired"
        );

        // Renew the username for the user with another one-year registration duration
        uint256 registrationDuration = 31536000;
        registrar.renew(node, registrationDuration);
        // Update the username expiration timestamp
        usernameExpiry[node] = block.timestamp.add(registrationDuration);
    }
}
