// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;


// Import necessary interfaces and libraries for handling ERC20 tokens and SafeMath
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PremiumPaymentContract {
    using SafeMath for uint256;

    // Address of the ERC20 token used for premium payments
    address public tokenAddress;

    // Mapping to track the user's insurance coverage status
    mapping(address => bool) public isCovered;

    // Event to notify when a premium payment is made
    event PremiumPaid(address indexed user, uint256 premiumAmount);

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    // Function to initiate a premium payment
    function payPremium(uint256 _premiumAmount) external {
        require(_premiumAmount > 0, "PremiumPaymentContract: Premium amount must be greater than zero");

        IERC20 token = IERC20(tokenAddress);
        address user = msg.sender;

        // Check if the user has sufficient balance for premium payment
        require(token.balanceOf(user) >= _premiumAmount, "PremiumPaymentContract: Insufficient balance");

        // Calculate the transaction fee based on the premium amount and token type
        uint256 fee = calculateTransactionFee(_premiumAmount, token);
        uint256 totalAmount = _premiumAmount.add(fee);

        // Transfer the total amount (premium + fees) from the user to this contract
        require(token.transferFrom(user, address(this), totalAmount), "PremiumPaymentContract: Transfer failed");

        // Update the user's insurance coverage status
        isCovered[user] = true;

        // Emit the PremiumPaid event
        emit PremiumPaid(user, _premiumAmount);
    }

    // Function to calculate the transaction fee based on the premium amount and token type
    function calculateTransactionFee(uint256 _premiumAmount, IERC20 _token) internal pure returns (uint256) {
        // Replace this with your preferred logic to calculate transaction fees for different token types
        // For simplicity, let's assume a 1% fee on the premium amount for all tokens
        return _premiumAmount.mul(1).div(100);
    }

    // Function to get the user's insurance coverage status
    function getInsuranceCoverageStatus(address user) external view returns (bool) {
        return isCovered[user];
    }
}
