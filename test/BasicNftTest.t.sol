// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testBasicNftName() external view {
        // array of bytes cannot be compared directly
        /*
            1. We can loop through the array and compare each element
            2. We can hash the array to bytes using keccak256 in solidity and compare the hash value
        */
        string memory name = basicNft.name();
        assert(
            keccak256(abi.encodePacked(name)) ==
                keccak256(abi.encodePacked("Doggie"))
        );
    }

    function testBasicNftSymbol() external view {
        // array of bytes cannot be compared directly
        /*
            1. We can loop through the array and compare each element
            2. We can hash the array to bytes using keccak256 in solidity and compare the hash value
        */
        string memory symbol = basicNft.symbol();
        assert(
            keccak256(abi.encodePacked(symbol)) ==
                keccak256(abi.encodePacked("DOG"))
        );
    }

    function testCanMintAndHaveABalance() external {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG_URI))
        );
    }
}
