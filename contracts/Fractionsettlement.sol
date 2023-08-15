// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;

contract FractionalSettlement {
    struct Claim {
        uint256 totalPayout; // Total payout for the claim
        mapping(address => uint256) userFractions; // Fractions of the payout for each user
    }

    mapping(uint256 => Claim) public claims; // Mapping of claim IDs to Claim objects

    // Event to notify when a claim is processed and fractions are distributed
    event ClaimProcessed(uint256 indexed claimId, uint256 totalPayout);

    constructor() {}

    // Function to initiate a claim and distribute fractions to participants
    function processClaim(
        uint256 claimId,
        address[] memory participants,
        uint256[] memory premiumContributions
    ) external {
        require(
            participants.length == premiumContributions.length,
            "FractionalSettlement: Invalid input lengths"
        );

        uint256 totalPayout = calculateTotalPayout(premiumContributions);

        claims[claimId].totalPayout = totalPayout;

        for (uint256 i = 0; i < participants.length; i++) {
            address participant = participants[i];
            uint256 fraction = (premiumContributions[i] * 1e18) / totalPayout; // Fraction as a fixed-point number
            claims[claimId].userFractions[participant] = fraction;
        }

        emit ClaimProcessed(claimId, totalPayout);
    }

    // Function to calculate the total payout based on premium contributions
    function calculateTotalPayout(
        uint256[] memory premiumContributions
    ) internal pure returns (uint256) {
        uint256 totalPayout = 0;
        for (uint256 i = 0; i < premiumContributions.length; i++) {
            totalPayout += premiumContributions[i];
        }
        return totalPayout;
    }

    // Function to retrieve the fraction of payout for a user in a specific claim
    function getUserFraction(
        uint256 claimId,
        address user
    ) external view returns (uint256) {
        return claims[claimId].userFractions[user];
    }
}
