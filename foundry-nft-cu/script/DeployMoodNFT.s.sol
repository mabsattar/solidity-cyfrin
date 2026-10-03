// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNFT is Script {
    function run() external returns (MoodNFT) {
        string memory sadSvg = vm.readFile("./img/sadSvg");
        string memory happySvg = vm.readFile("./img/happySvg");

        vm.startBroadcast();
        MoodNFT moodNFT = new MoodNFT(svgToImageURI(sadSvg), svgToImageURI(happySvg));
        vm.stopBroadcast();

        return moodNFT;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(svg));

        return string(string.concat(baseURL, svgBase64Encoded));
    }
}

