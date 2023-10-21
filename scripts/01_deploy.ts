import { ethers, network } from "hardhat";
import { NusicMetadata, NusicMetadata__factory } from "../typechain-types";

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const NusicMetadata:NusicMetadata__factory = await ethers.getContractFactory("NusicMetadata");
  const nusicMetadata:NusicMetadata = await NusicMetadata.deploy()
  await nusicMetadata.deployed();

  console.log("NusicMetadata deployed to:", nusicMetadata.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
