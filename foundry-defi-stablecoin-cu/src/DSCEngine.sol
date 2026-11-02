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

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title DSCEngine
 * @author AB Sattar
 *
 * The system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $1 peg at all times.
 * This is a stablecoin with the properties:
 * - Exogenously Collateralized
 * - Dollar Pegged
 * - Algorithmically Stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
 *
 * Our DSC system should always be "overcollateralized". At no point, should the value of
 * all collateral < the $ backed value of all the DSC.
 *
 * @notice This contract is the core of the Decentralized Stablecoin system. It handles all the logic
 * for minting and redeeming DSC, as well as depositing and withdrawing collateral.
 * @notice This contract is based on the MakerDAO DSS(DAI) system
 */

contract DSCEngine is ReentrancyGuard {
    ////////////
    // errors //
    ////////////
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TransferFailed();

    /////////////////////
    // state variables //
    /////////////////////
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDscMinted) private s_DSCMinted;

    DecentralizedStableCoin private immutable i_dsc;

    address[] private s_collateralTokens;

    ////////////
    // events //
    ////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    ///////////////
    // modifiers //
    ///////////////
    modifier moreThanZero(uint256 amount) {
        if (amount <= 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }

    ///////////////
    // functions //
    ///////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    ////////////////////////
    // external functions //
    ////////////////////////
    /**
      *  @notice follows CEI pattern
      *  @param tokenCollateralAddress: The ERC20 token address of the collateral you're depositing
      *  @param amountCollateral: The amount of collateral you're depositing
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);

        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);

        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function depositCollateralAndMintDsc() external {}

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    /**
      * @param amountDscToMint: The amount of DSC you want to mint
      * you can only mint DSC if you have enough colalteral
     */
    function mintDsc(uint256 amountDscToMint) public moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
    }

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    ///////////////////////////////////////
    // private & internal view functions //
    ///////////////////////////////////////

    function _revertIfHealthFactorisBroken(address user) internal view {}

    /**
      * Returns how close to liquidation a user is
      * If a user goes below 1, then they can be liquidated.
     */
    function _healthFactor(address user) private view returns (uint256) {}

    function getAccountInformation(address user)
        private
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    //////////////////////////////////////
    // public & external view functions //
    //////////////////////////////////////

    function getAccountCollateralValue(address user) public pure returns (uint256 totalCollateralValueInUsd) {
	for(uint256 i=0; i < s_collateralTokens.length; i++) {
	    address token = s_collateralTokens[i];
	    uint256 amount = s_collateralDeposit[user][token];
	    totalCollateralValueInUsd += ...
	}
	return totalCollateralValueInUsd;
    }
}
