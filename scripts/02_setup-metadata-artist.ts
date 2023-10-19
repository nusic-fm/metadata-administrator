import { ethers, network } from "hardhat";
import { NusicMetadataFactory, NusicMetadataFactory__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const NusicMetadataFactory:NusicMetadataFactory__factory = await ethers.getContractFactory("NusicMetadataFactory");
  const nusicMetadataFactory:NusicMetadataFactory = await NusicMetadataFactory.attach(addresses[network.name].nusicMetadataFactory);

  console.log("NusicMetadataFactory deployed to:", nusicMetadataFactory.address);

  const txt1 = await nusicMetadataFactory.setupMetadataForArtist("Abc", "xyz");
  console.log("txt1.hash setupMetadataForArtist = ",txt1.hash);
  const txtReceipt1 = await txt1.wait();
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
