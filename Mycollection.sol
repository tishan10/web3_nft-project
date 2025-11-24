// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyCollection is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 public maxSupply;
    uint256 public price; // price in wei
    uint256 public totalMinted;

    constructor(uint256 _maxSupply, uint256 _price) ERC721("MyNFTCollection", "MYNFT") {
        maxSupply = _maxSupply;
        price = _price;
    }

    /// @notice Public mint with tokenURI metadata
    function mint(string memory tokenURI) public payable {
        require(totalMinted < maxSupply, "Sold out");
        require(msg.value >= price, "Not enough ETH");

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        totalMinted++;
    }

    /// @notice Owner can withdraw ETH collected
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
