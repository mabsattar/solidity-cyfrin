// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoodNFT is ERC721 {
    string private s_sadSvg;
    string private s_happySvg;
    uint256 private s_tokenCounter;

    constructor(string memory sadSvg, string memory happySvg) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvg = sadSvg;
        s_happySvg = happySvg;
    }
}
