// SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";

contract BasicNFTTest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;

    address public USER = makeAddr("user");

    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNFT.name();
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNFT.symbol();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));

        // assertEq(expectedName, actualName);
        // assertEq(expectedSymbol, actualSymbol);
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNFT.mintNFT(PUG);

        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
    }
}
