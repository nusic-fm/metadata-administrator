// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract NusicEditionMetadata is Ownable, ReentrancyGuard {
    using Strings for uint256;

    string public artistName;
    string public artistId;
    address public artistAddress;
    uint256 public metadataIndex;

    address public manager;

    struct Metadata {
        uint256 index;
        address contributorAddress;
        address nftAddress;
        string[] metadataFileReferenceId;
    }

    mapping(uint256 => Metadata) public usersMetadata;

    event PublishMetadata(uint256 index, address contributorAddress, address nftAddress, string metadataFileReferenceId);
    event UpdateMetadata(uint256 index, string newMetadataFileReferenceId);

    modifier onlyArtist() {
        require((artistAddress == msg.sender), "Caller needs to be Artist of Contract");
        _;
    }

    modifier onlyArtistOrManager() {
        require((artistAddress== msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor(string memory _artistName, string memory _artistId, address _artistAddress) {
        require(_artistAddress != address(0), "Null Address Provided");
        require(bytes(_artistName).length > 0, "Artist name cannot be empty");
        require(bytes(_artistId).length > 0, "Artist Id cannot be empty");
        artistName = _artistName;
        artistId = _artistId;
        artistAddress = _artistAddress;
    }

    function publishMetadata(string memory _metadataFileReferenceId, address _nftAddress) public onlyArtist nonReentrant {
        require(bytes(_metadataFileReferenceId).length > 0, "Meatadata file CID cannot be empty");
        require(_nftAddress != address(0), "Null Address Provided");
        Metadata storage data = usersMetadata[metadataIndex];
        data.index = metadataIndex;
        data.contributorAddress = msg.sender;
        data.nftAddress = _nftAddress;
        data.metadataFileReferenceId.push(_metadataFileReferenceId);
        emit PublishMetadata(metadataIndex, msg.sender, _nftAddress, _metadataFileReferenceId);
        metadataIndex++;
    }

    function updateMetadata(uint256 _metadataIndex, string memory _newMetadataFileReferenceId) public onlyArtist nonReentrant {
        require(bytes(_newMetadataFileReferenceId).length > 0, "Meatadata file CID cannot be empty");
        Metadata storage data = usersMetadata[_metadataIndex];
        require(data.nftAddress != address(0), "Metadata not found");
        data.metadataFileReferenceId.push(_newMetadataFileReferenceId);
        emit UpdateMetadata(_metadataIndex, _newMetadataFileReferenceId);
    }

    function getMetadata(uint256 _metadataIndex) public view returns(Metadata memory) {
        return usersMetadata[_metadataIndex];
    }

    function getAllMetadata() public view returns(Metadata[] memory _metadata){
        for (uint256 i = 0; i < metadataIndex; i++) {
            _metadata[i]=(usersMetadata[i]);
        }
    }

    function setManager(address _manager) public onlyArtist {
        manager = _manager;
    }

}