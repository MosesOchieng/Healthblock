// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;


// Import necessary interfaces and libraries for handling ERC20 tokens and SafeMath
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ClaimsProcessingContract {
    using SafeMath for uint256;

    // Mapping to track claim status of each user
    mapping(address => bool) public isClaimValid;

    // Address of the ERC20 token used for payout
    address public tokenAddress;

    // Mapping to store the user's insurance policy details
    mapping(address => uint256) public insurancePolicyAmount;
    mapping(address => uint256) public insurancePolicyCoverage;

    // Event to notify when a claim is processed and payout is initiated
    event ClaimProcessed(address indexed user, uint256 payoutAmount);

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    // Function for users to submit an insurance claim
    function submitClaim(uint256 _claimAmount) external {
        address user = msg.sender;

        // Check if the user has an active insurance policy
        require(
            insurancePolicyCoverage[user] > 0,
            "ClaimsProcessingContract: User has no active policy"
        );

        // Validate the claim amount against the coverage of the user's insurance policy
        require(
            _claimAmount <= insurancePolicyCoverage[user],
            "ClaimsProcessingContract: Claim amount exceeds coverage"
        );

        // Assuming the claim is valid based on predefined criteria for simplicity.
        isClaimValid[user] = true;

        // Initiates the payout process for the valid claim
        initiatePayout(user, _claimAmount);

        // Emit the ClaimProcessed event
        emit ClaimProcessed(user, _claimAmount);
    }

    // Function to initiate the payout process
    function initiatePayout(address user, uint256 _claimAmount) internal {
        IERC20 token = IERC20(tokenAddress);

        // Calculate the payout amount based on the claim and user's policy details
        uint256 payoutAmount = calculatePayoutAmount(user, _claimAmount);

        // Transfer the payout amount to the user's address
        require(
            token.transfer(user, payoutAmount),
            "ClaimsProcessingContract: Transfer failed"
        );
    }

    // Function to calculate the payout amount for the claim
    function calculatePayoutAmount(
        address user,
        uint256 _claimAmount
    ) internal view returns (uint256) {
        // Replace this with your preferred logic to calculate the payout amount based on the claim and policy details
        // For simplicity, let's assume a fixed payout percentage (50%) of the claim amount
        uint256 payoutPercentage = 50;
        return _claimAmount.mul(payoutPercentage).div(100);
    }

    // Function to set the insurance policy details for a user
    function setInsurancePolicy(
        address user,
        uint256 _policyAmount,
        uint256 _policyCoverage
    ) external {
        insurancePolicyAmount[user] = _policyAmount;
        insurancePolicyCoverage[user] = _policyCoverage;
    }

    // Function to check if a user's claim is valid
    function isClaimValidForUser(address user) external view returns (bool) {
        return isClaimValid[user];
    }

    // Function to get the user's insurance policy details
    function getInsurancePolicy(
        address user
    ) external view returns (uint256 policyAmount, uint256 policyCoverage) {
        return (insurancePolicyAmount[user], insurancePolicyCoverage[user]);
    }
}
