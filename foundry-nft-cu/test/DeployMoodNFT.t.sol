// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DeployMoodNFT} from "../script/DeployMoodNFT.s.sol";
import {Test} from "forge-std/Test.sol";

contract DeployMoodNFT is Test {
    DeployMoodNFT public deployer;

    function setUp() public view {
        deployer = new DeployMoodNFT();
    }
}
