// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract InsuranceContract {
    // Define insurance package details
    struct InsurancePackage {
        string name;
        uint256 price;
    }

    InsurancePackage[] public insurancePackages;

    mapping(address => bool) public isSubscribed;

    event Subscribed(address indexed user, string packageName);

    constructor() {
        insurancePackages.push(InsurancePackage("Basic Package", 1 ether));
        insurancePackages.push(InsurancePackage("Standard Package", 2 ether));
        insurancePackages.push(InsurancePackage("Premium Package", 3 ether));
    }

    function subscribe(uint256 packageIndex) external payable {
        require(packageIndex < insurancePackages.length, "Invalid package index");
        require(!isSubscribed[msg.sender], "Already subscribed");

        InsurancePackage storage selectedPackage = insurancePackages[packageIndex];
        require(msg.value >= selectedPackage.price, "Insufficient funds");

        isSubscribed[msg.sender] = true;
        emit Subscribed(msg.sender, selectedPackage.name);
    }

    function getPackageCount() external view returns (uint256) {
        return insurancePackages.length;
    }
}
