// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./NusicMetadata.sol";
import "hardhat/console.sol";

contract NusicMetadataFactory is Ownable, ReentrancyGuard {
    using Strings for uint256;

    // artist address => metadata contract address
    mapping(address => address) public usersMetadataContract;

    event SetupMetadata(string _artistName, string _artistId, address _metadataContract, string _type);

    function setupMetadataForArtist(string memory _artistName, string memory _artistId) public nonReentrant{
        //NusicMetadata metadata = new NusicMetadata(_artistName, _artistId, msg.sender);
        //usersMetadataContract[msg.sender] = address(metadata);
        //emit SetupMetadata(_artistName, _artistId, address(metadata), "Collection");
    }

    function getMetadataContract(address userAddress) public view returns(address) {
        return usersMetadataContract[userAddress];
    }

    function removeMetadataContract(address _artistAddress) public onlyOwner{
        delete usersMetadataContract[_artistAddress];
    }

}