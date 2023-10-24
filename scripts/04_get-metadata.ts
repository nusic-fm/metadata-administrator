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
    metadataType: BigNumber;
  }

  const NusicMetadata:NusicMetadata__factory = await ethers.getContractFactory("NusicMetadata");
  const nusicMetadata:NusicMetadata = await NusicMetadata.attach(addresses[network.name].nusicMetadata);
  console.log("NusicMetadata address:", nusicMetadata.address);

  const metadata:Metadata = await nusicMetadata.getMetadata("0x5FbDB2315678afecb367f032d93F642f64180aa3", 1);
  console.log(metadata);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
