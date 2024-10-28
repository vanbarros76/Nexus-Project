# LiquidNexus

LiquidNexus is a decentralized finance (DeFi) project that implements staking and cross-chain transfer functionalities using smart contracts on the Ethereum blockchain.

## Features

- ERC20 token functionality
- Staking mechanism with rewards
- Cross-chain transfer capabilities

## Prerequisites

Before you begin, ensure you have met the following requirements:
* You have installed [Node.js](https://nodejs.org/) (version 12.x or later)
* You have a [Metamask](https://metamask.io/) wallet with some test ETH on the Goerli network
* You have an [Infura](https://infura.io/) account for deploying to Ethereum networks
* You have an [Etherscan](https://etherscan.io/) account for contract verification

## Installation

To install LiquidNexus, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/liquidnexus.git
   ```
2. Navigate to the project directory:
   ```
   cd liquidnexus
   ```
3. Install the dependencies:
   ```
   npm install
   ```

## Configuration

1. Create a `.env` file in the root directory with the following content:
   ```
   INFURA_PROJECT_ID=your_infura_project_id
   PRIVATE_KEY=your_wallet_private_key
   ETHERSCAN_API_KEY=your_etherscan_api_key
   ```
   Replace the placeholder values with your actual credentials.

2. Update the `hardhat.config.js` file with your network configurations if necessary.

## Usage

### Compiling the contract

To compile the LiquidNexus contract, run:

npx hardhat compile


### Running tests

To run the test suite, use:

npx hardhat test


### Deploying the contract

To deploy the contract to the Goerli test network:

npx hardhat run scripts/deploy.js --network goerli


### Verifying the contract on Etherscan

After deployment, verify the contract on Etherscan:

npx hardhat verify --network goerli DEPLOYED_CONTRACT_ADDRESS

Replace `DEPLOYED_CONTRACT_ADDRESS` with the address of your deployed contract.

## Interacting with the contract

You can interact with the deployed contract using the Hardhat console or by integrating it into a frontend application.

To open the Hardhat console:

npx hardhat console --network goerli

Example commands:

javascript
const LiquidNexus = await ethers.getContractFactory("LiquidNexus");
const liquidNexus = await LiquidNexus.attach("DEPLOYED_CONTRACT_ADDRESS");
await liquidNexus.stake(ethers.utils.parseEther("1"));


## Contributing to LiquidNexus

To contribute to LiquidNexus, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. Create the pull request.

Alternatively, see the GitHub documentation on [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Contact

If you want to contact me, you can reach me at <vanessabarros.tech@gmail.com>.

## License

This project uses the following license: [MIT License](LICENSE).
