// SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volatility coin
// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions
// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERc20/extensions/ERC20Burnable.sol";

/*
 *@title: DecentralizedStableCoin
 *@author: AB
 *CikkaterakL Exigenous(ETH & BTC)
 *Minting: Algorithmic
 *Relative Stability: Pegged to USD
 *
 * This is the contract meant to be governed by DSCEngine. This contract is just the ERC20 implementation of our stablecoin system
 */

contract DecentralizedStableCoin {
    constructor() ERC20("DecentralizedStableCoin", "DSC") {}
}
