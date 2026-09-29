// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";

contract DeployMoodNFT is Script {
    function run() external returns (MoodNFT) {}

    function svgToImageURI(string memory svg) public pure returns (string memory) {}
}
