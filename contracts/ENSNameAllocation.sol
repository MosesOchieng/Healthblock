// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "@ensdomains/ens/contracts/ENS.sol";
import "./SpruceID.sol"; // Import the SpruceID contract

contract ENSNameAllocation {
    // ENS contract address
    ENS public ens;
    
    // Address of the SpruceID contract
    address public spruceIDAddress;

    // Mapping to store the user's ENS name allocation status
    mapping(address => bool) public hasAllocatedENSName;

    constructor(address _ensAddress, address _spruceIDAddress) {
        ens = ENS(_ensAddress);
        spruceIDAdd
        ress = _spruceIDAddress;
    }

    // Function to allocate an ENS name to an authenticated user
    function allocateENSName(string calldata _ensName) external {
        require(isIdentityVerifiedForUser(msg.sender), "ENSNameAllocation: User is not authenticated");
        require(!hasAllocatedENSName[msg.sender], "ENSNameAllocation: ENS name already allocated");
        require(bytes(_ensName).length > 0, "ENS name cannot be empty");

        bytes32 nodeHash = keccak256(abi.encodePacked(ens.root(), keccak256(bytes(_ensName))));
        
        // Allocate the ENS name to the user
        address owner = ens.owner(nodeHash);
        if (owner == address(0)) {
            // The ENS name is not yet registered
            ens.setOwner(nodeHash, msg.sender);
            hasAllocatedENSName[msg.sender] = true;
        } else {
            // The ENS name is already registered
            revert("ENSNameAllocation: ENS name is already registered");
        }

        // Redirect to the next page with the allocated ENS name as a query parameter
        string memory nextPageUrl = string(abi.encodePacked(" ../Dashboard/index.html?ensName=", _ensName));
        emit Redirect(msg.sender, nextPageUrl);
    }

    event Redirect(address indexed user, string nextPageUrl);
}
