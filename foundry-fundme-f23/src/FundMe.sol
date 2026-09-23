// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "./PriceConverter.sol";

error FundMe_NotOwner();

contract FundMe {
    uint256 public constant MINIMUM_USD = 5e18;

    using PriceConverter for uint256;

    address[] private s_funders;

    AggregatorV3Interface private s_priceFeed;

    mapping(address funder => uint256 amountFunded)
        private s_addressToAmountFunded;

    address private immutable i_owner;

    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    function fund() public payable {
        // require(getConversionRate(msg.value) >= minimumUSD, "didn't send enough ETH");
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didn't send enough ETH"
        );
        s_addressToAmountFunded[msg.sender] =
            s_addressToAmountFunded[msg.sender] +
            msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        // using for loop to iterate through the addresses of the users
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // transfer method to transfer tokens
        // payable(msg.sender).transfer(address(this).balance);
        // send method to send/transfer tokents
        //note: both transfer and send are set to limited gas at 2300 only
        // bool success = payable(msg.sender).send(address(this).balance);
        // call is flexible and doesn't have a gas limit but requires conversaion of address of the receiver to payable and add the value inside cxurly brackets
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "call failed");
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "sender is not owner");
        if (msg.sender != i_owner) {
            revert FundMe_NotOwner();
        }
        _;
    }

    function getPrice() internal view returns (uint) {
        // we need address
        // ABI
        (, int256 price, , , ) = s_priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        // how much 1 ETH is worth
        // (2000_00000000000000000 * 1_0000000000000000) / 1e18
        // $2000 = 1 ETH
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = ((ethPrice * ethAmount) / 1e18);
        return ethAmountInUSD;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    // receive and fallback functions
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     * view/pure functions (getters)
     */
    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
