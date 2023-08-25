// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract ClaimsProcessingContract {
    // Mapping to track claim status of each user
    mapping(address => bool) public isClaimValid;

    // Mapping to store the user's insurance policy details
    mapping(address => uint256) public insurancePolicyAmount;
    mapping(address => uint256) public insurancePolicyCoverage;

    // Event to notify when a claim is processed and payout is initiated
    event ClaimProcessed(address indexed user, uint256 payoutAmount);

    function submitClaim(uint256 _claimAmount) external {
        require(
            insurancePolicyCoverage[msg.sender] > 0,
            "User has no active policy"
        );
        require(
            _claimAmount <= insurancePolicyCoverage[msg.sender],
            "Claim amount exceeds coverage"
        );
        require(!isClaimValid[msg.sender], "Claim has already been submitted");

        isClaimValid[msg.sender] = true;

        uint256 payoutAmount = calculatePayoutAmount(_claimAmount);

        emit ClaimProcessed(msg.sender, payoutAmount);
    }

    function calculatePayoutAmount(uint256 _claimAmount) internal pure returns (uint256) {
        uint256 payoutPercentage = 50;
        return _claimAmount * payoutPercentage / 100;
    }

    function setInsurancePolicy(
        address _user,
        uint256 _policyAmount,
        uint256 _policyCoverage
    ) external {
        insurancePolicyAmount[_user] = _policyAmount;
        insurancePolicyCoverage[_user] = _policyCoverage;
    }

    function getInsurancePolicy(address _user) external view returns (uint256 policyAmount, uint256 policyCoverage) {
        return (insurancePolicyAmount[_user], insurancePolicyCoverage[_user]);
    }
}
