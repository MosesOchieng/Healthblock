// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // Import Chainlink's AggregatorV3Interface

contract CollateralizedInsurance is Ownable {
    mapping(address => uint256) public collateralBalances;
    mapping(address => bool) public isInsured;

    AggregatorV3Interface internal priceFeed; // Chainlink's price feed oracle

    uint256 public claimThreshold = 80; // Percentage threshold for a valid claim (e.g., 80%)

    event CollateralDeposited(address indexed user, uint256 amount);
    event InsuranceActivated(address indexed user);
    event ClaimProcessed(address indexed user, uint256 payout);

    constructor(address _priceFeedAddress) {
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    function depositCollateral() external payable {
        require(
            msg.value > 0,
            "CollateralizedInsurance: Amount must be greater than 0"
        );

        collateralBalances[msg.sender] += msg.value;
        emit CollateralDeposited(msg.sender, msg.value);
    }

    function activateInsurance() external {
        require(
            collateralBalances[msg.sender] > 0,
            "CollateralizedInsurance: No collateral deposited"
        );
        require(
            !isInsured[msg.sender],
            "CollateralizedInsurance: Already insured"
        );

        isInsured[msg.sender] = true;
        emit InsuranceActivated(msg.sender);
    }

    function makeClaim() external {
        require(isInsured[msg.sender], "CollateralizedInsurance: Not insured");

        uint256 currentCollateralValue = getCurrentCollateralValue(msg.sender);
        require(
            currentCollateralValue <
                ((collateralBalances[msg.sender] * claimThreshold) / 100),
            "CollateralizedInsurance: Collateral value exceeds claim threshold"
        );

        // Calculate payout based on collateral value and predefined criteria
        uint256 payout = calculatePayout(currentCollateralValue);

        // Transfer payout to the user
        payable(msg.sender).transfer(payout);

        emit ClaimProcessed(msg.sender, payout);
    }

    function getCurrentCollateralValue(
        address user
    ) internal view returns (uint256) {
        (, int256 currentPrice, , , ) = priceFeed.latestRoundData();
        uint256 collateralValue = (uint256(currentPrice) *
            collateralBalances[user]) / 1e8; // Chainlink returns price with 8 decimals
        return collateralValue;
    }

    function calculatePayout(
        uint256 collateralValue
    ) internal pure returns (uint256) {
        // Implement your own payout calculation logic here based on collateral value
        // Example: payout = collateralValue * 90 / 100
        return (collateralValue * 90) / 100;
    }

    // Owner function to update the claim threshold
    function setClaimThreshold(uint256 _threshold) external onlyOwner {
        claimThreshold = _threshold;
    }
}
