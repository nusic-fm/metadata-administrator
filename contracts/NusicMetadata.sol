// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract NusicMetadata is Ownable, ReentrancyGuard {
    using Strings for uint256;

    uint256 public metadataIndex;

    address public manager;

    struct Metadata {
        uint256 index;
        address contributorAddress;
        address nftAddress;
        uint256 tokenId;
        string[] metadataFileReferenceId;
        uint256 metadataType; // 1 = Collection, 2 = Edition, 3 = Lazy 
                            // Edition will not have token id, Lazy will not have token id and contract address
    }

    mapping(string => Metadata) public usersMetadata;

    event PublishMetadata(uint256 index, uint256 metadataType, address contributorAddress, address nftAddress, uint256 tokenId,  string metadataFileReferenceId);
    event UpdateMetadata(address nftAddress, uint256 tokenId, string newMetadataFileReferenceId);


    modifier onlyOwnerOrManager() {
        require((owner()== msg.sender) || (manager == msg.sender), "Caller needs to be Owner or Manager");
        _;
    }

    constructor() {
    }

    function publishMetadata(string memory _metadataFileReferenceId, address _nftAddress, uint256 _tokenId, uint256 _metadataType) internal onlyOwnerOrManager {
        require(bytes(_metadataFileReferenceId).length > 0, "Meatadata file CID cannot be empty");
        require(_nftAddress != address(0), "Null Address Provided");
        string memory uniqueId = string(abi.encodePacked(_nftAddress, _tokenId));
        Metadata storage data = usersMetadata[uniqueId];

        require(data.nftAddress == address(0), "Metadata already exists");

        data.index = metadataIndex;
        data.contributorAddress = msg.sender;
        data.nftAddress = _nftAddress;
        data.tokenId = _tokenId;
        data.metadataFileReferenceId.push(_metadataFileReferenceId);
        data.metadataType = _metadataType;
        emit PublishMetadata(metadataIndex, _metadataType, msg.sender, _nftAddress, _tokenId, _metadataFileReferenceId);
        metadataIndex++;
    }

    function publishCollectionMetadata(string memory _metadataFileReferenceId, address _nftAddress) public nonReentrant {
        publishMetadata(_metadataFileReferenceId, _nftAddress, 0, 1);
    }

    function publishEditionMetadata(string memory _metadataFileReferenceId, address _nftAddress, uint256 _tokenId) public nonReentrant {
        publishMetadata(_metadataFileReferenceId, _nftAddress, _tokenId, 2);
    }

    function publishLazyMetadata(string memory _metadataFileReferenceId) public nonReentrant {
        publishMetadata(_metadataFileReferenceId, address(0), 0, 3);
    }

    function updateMetadata(address _nftAddress, uint256 _tokenId, string memory _newMetadataFileReferenceId) public onlyOwnerOrManager nonReentrant {
        require(bytes(_newMetadataFileReferenceId).length > 0, "Meatadata file CID cannot be empty");
        string memory uniqueId = string(abi.encodePacked(_nftAddress, _tokenId));
        Metadata storage data = usersMetadata[uniqueId];
        require(data.nftAddress != address(0), "Metadata not found");
        data.metadataFileReferenceId.push(_newMetadataFileReferenceId);
        emit UpdateMetadata(_nftAddress, _tokenId, _newMetadataFileReferenceId);
    }

    function getMetadata(address _nftAddress, uint256 _tokenId) public view returns(Metadata memory) {
        string memory uniqueId = string(abi.encodePacked(_nftAddress, _tokenId));
        return usersMetadata[uniqueId];
    }

    function metadataCount() public view returns(uint256) {
        return metadataIndex;
    }
    /*
    function getAllMetadata() public view returns(Metadata[] memory _metadata){
        for (uint256 i = 0; i < metadataIndex; i++) {
            _metadata[i]=(usersMetadata[i]);
        }
    }
    */

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

}