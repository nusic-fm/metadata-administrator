import { ethers, network } from "hardhat";
import { NusicMetadata, NusicMetadataFactory, NusicMetadataFactory__factory, NusicMetadata__factory } from "../typechain-types";

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const NusicMetadataFactory:NusicMetadataFactory__factory = await ethers.getContractFactory("NusicMetadataFactory");
  const nusicMetadataFactory:NusicMetadataFactory = await NusicMetadataFactory.deploy();
  await nusicMetadataFactory.deployed();

  console.log("NusicMetadataFactory deployed to:", nusicMetadataFactory.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
