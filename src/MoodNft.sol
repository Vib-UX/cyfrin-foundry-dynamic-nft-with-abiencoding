// SPDX-License-Identifier :MIT

pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    //errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum NFTState {
        HAPPY,
        SAD
    }

    mapping(uint256 => NFTState) private s_tokenIdToState;

    // Pass base64 encoded uri images to the contructor
    constructor(
        string memory sadSvg,
        string memory happySvg
    ) ERC721("MoodNft", "MN") {
        s_sadSvgImageUri = sadSvg;
        s_happySvgImageUri = happySvg;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToState[s_tokenCounter] = NFTState.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            s_tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name: "',
                                name(),
                                '", description: "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": ',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
