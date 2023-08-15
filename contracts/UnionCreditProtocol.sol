// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.1 <0.9.0;

contract UnionCreditProtocol {
    // Mapping to store user credit scores
    mapping(address => uint256) public creditScores;
    
    // Event to notify when a user's credit score is updated
    event CreditScoreUpdated(address indexed user, uint256 creditScore);

    constructor() {}

    // Function to update a user's credit score
    function updateCreditScore(address user, uint256 newCreditScore) external {
        require(newCreditScore >= 0, "Credit score cannot be negative");
        creditScores[user] = newCreditScore;

        // Emit the CreditScoreUpdated event
        emit CreditScoreUpdated(user, newCreditScore);
    }

    // Function to check creditworthiness of a user
    function checkCreditworthiness(address user, uint256 income, bool hasSteadyEmployment) external view returns (bool) {
        // Calculate a weighted score based on credit score, income, and employment history
        uint256 creditScoreWeight = 40;
        uint256 incomeWeight = 30;
        uint256 employmentWeight = 30;

        uint256 weightedScore = (creditScores[user] * creditScoreWeight) +
                                (income * incomeWeight) +
                                (hasSteadyEmployment ? employmentWeight : 0);

        // Calculate the threshold based on weighted score
        uint256 threshold = 800; // Example threshold for creditworthiness

        return weightedScore >= threshold;
    }
}
