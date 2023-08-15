// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;


// Import necessary interfaces and libraries for interacting with the Union Credit Protocol
import "./UnionCreditProtocol.sol";

contract CreditAssessmentContract {
    // Address of the Union Credit Protocol contract
    address public unionCreditProtocolAddress;

    // Event to notify when a credit assessment is performed
    event CreditAssessmentPerformed(address indexed user, bool isCreditworthy);

    constructor(address _unionCreditProtocolAddress) {
        unionCreditProtocolAddress = _unionCreditProtocolAddress;
    }

    // Function to perform credit assessment using the Union Credit Protocol
    function assessCreditworthiness(address user) external returns (bool) {
        // Assume the Union Credit Protocol contract has a function `checkCreditworthiness`
        // that assesses the user's creditworthiness and returns a boolean indicating the result.
        UnionCreditProtocol unionCreditProtocol = UnionCreditProtocol(
            unionCreditProtocolAddress
        );

        // Perform credit assessment
        bool isCreditworthy = unionCreditProtocol.checkCreditworthiness(user);

        // Emit the CreditAssessmentPerformed event
        emit CreditAssessmentPerformed(user, isCreditworthy);

        return isCreditworthy;
    }
}
