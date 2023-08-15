// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1 <0.9.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InsurancePolicyNFT is ERC721URIStorage, Ownable {
    uint256 private nextTokenId = 1;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    function mintNFT(
        address recipient,
        string memory tokenURI
    ) external onlyOwner {
        uint256 tokenId = nextTokenId;
        nextTokenId++;

        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function setTokenURI(
        uint256 tokenId,
        string memory tokenURI
    ) external onlyOwner {
        _setTokenURI(tokenId, tokenURI);
    }
}
