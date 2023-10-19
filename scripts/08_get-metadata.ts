import { ethers, network } from "hardhat";
import { NusicMetadata, NusicMetadataFactory, NusicMetadataFactory__factory, NusicMetadata__factory } from "../typechain-types";
import { BigNumber } from "ethers";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  interface Metadata {
    index: BigNumber;
    contributorAddress: string;
    nftAddress: string;
    tokenId: BigNumber;
    metadataFileReferenceId: string[];
    
  }

  const NusicMetadataFactory:NusicMetadataFactory__factory = await ethers.getContractFactory("NusicMetadataFactory");
  const nusicMetadataFactory:NusicMetadataFactory = await NusicMetadataFactory.attach(addresses[network.name].nusicMetadataFactory);

  console.log("NusicMetadataFactory deployed to:", nusicMetadataFactory.address);

  const nusicMetadataContractAddress = await nusicMetadataFactory.getMetadataContract(owner.address);
  console.log("nusicMetadataContractAddress = ",nusicMetadataContractAddress);

  const NusicMetadata:NusicMetadata__factory = await ethers.getContractFactory("NusicMetadata");
  const nusicMetadata:NusicMetadata = await NusicMetadata.attach(nusicMetadataContractAddress);
  console.log("NusicMetadata address:", nusicMetadata.address);

  const metadata:Metadata = await nusicMetadata.getMetadata(0);
  console.log(metadata);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
