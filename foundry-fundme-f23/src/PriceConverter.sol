// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint) {
        // we need address
        // ABI
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // how much 1 ETH is worth
        // (2000_00000000000000000 * 1_0000000000000000) / 1e18
        // $2000 = 1 ETH
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUSD = ((ethPrice * ethAmount) / 1e18);
        return ethAmountInUSD;
    }
}
