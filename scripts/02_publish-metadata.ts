import { ethers, network } from "hardhat";
import { NusicMetadata, NusicMetadataFactory, NusicMetadataFactory__factory, NusicMetadata__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);

  const NusicMetadata:NusicMetadata__factory = await ethers.getContractFactory("NusicMetadata");
  const nusicMetadata:NusicMetadata = await NusicMetadata.attach(addresses[network.name].nusicMetadata);
  console.log("NusicMetadata address:", nusicMetadata.address);  

  const txt1 = await nusicMetadata.publishEditionMetadata("QmY2Hr578q1Pit51CXBKDticMCgdmxfXbJ4iigG7KQHyWK","0x5FbDB2315678afecb367f032d93F642f64180aa3",2);
  console.log("txt1.hash publishMetadata = ",txt1.hash);
  const txtReceipt1 = await txt1.wait();
/*
  const txt2 = await nusicMetadata.publishEditionMetadata("QmY2Hr578q1Pit51CXBKDticMCgdmxfXbJ4iigG7KQHyAC","0x70997970C51812dc3A010C7d01b50e0d17dc79C8",2);
  console.log("txt2.hash publishMetadata = ",txt2.hash);
  const txtReceipt2 = await txt2.wait();
*/
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
