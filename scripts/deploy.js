const { ethers, upgrades } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const LiquidNexus = await ethers.getContractFactory("LiquidNexus");
  
  console.log("Deploying LiquidNexus...");
  const liquidNexus = await upgrades.deployProxy(LiquidNexus, ["LiquidNexus Token", "NEXUS"], { initializer: 'initialize' });
  await liquidNexus.deployed();

  console.log("LiquidNexus deployed to:", liquidNexus.address);

  // Verify the contract on Etherscan
  console.log("Verifying contract on Etherscan...");
  await hre.run("verify:verify", {
    address: liquidNexus.address,
    constructorArguments: [],
  });

  console.log("Contract verified on Etherscan");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });