import { ethers, network } from "hardhat";
import { NusicMetadata, NusicMetadataFactory, NusicMetadataFactory__factory, NusicMetadata__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);


  const NusicMetadataFactory:NusicMetadataFactory__factory = await ethers.getContractFactory("NusicMetadataFactory");
  const nusicMetadataFactory:NusicMetadataFactory = await NusicMetadataFactory.attach(addresses[network.name].nusicMetadataFactory);

  console.log("NusicMetadataFactory deployed to:", nusicMetadataFactory.address);

  const nusicMetadataContractAddress = await nusicMetadataFactory.getMetadataContract(owner.address);
  console.log("nusicMetadataContractAddress = ",nusicMetadataContractAddress);

  const NusicMetadata:NusicMetadata__factory = await ethers.getContractFactory("NusicMetadata");
  const nusicMetadata:NusicMetadata = await NusicMetadata.attach(nusicMetadataContractAddress);
  console.log("NusicMetadata address:", nusicMetadata.address);

  const txt1 = await nusicMetadata.updateMetadata(0,"MmY2Hr578q1Pit51CXBKDticMCgdmxfXbJ4iigG7KQHyPQ");
  console.log("txt1.hash updateMetadata = ",txt1.hash);
  const txtReceipt1 = await txt1.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
