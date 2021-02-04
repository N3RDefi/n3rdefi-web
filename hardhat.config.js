/* global task ethers */
import '@nomiclabs/hardhat-waffle'
import '@nomiclabs/hardhat-ethers'
import './node_modules/hardhat-contract-sizer'
import './node_modules/solidity-coverage'
import './contracts/tasks/generateDiamondABI'

require('dotenv').config()

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("Accounts", "Prints a list of Accounts", async () => {
  const accounts = await ethers.getSigners();

  console.log('accounts', accounts)
  // for (const account of accounts) {
  //   console.log(await account.getAddress())
  // }
})

// https://github.com/withtally/Tutorial-Deploy-Governance/blob/main/hardhat.config.jshttps://github.com/withtally/Tutorial-Deploy-Governance/blob/main/hardhat.config.js
// task("Deploy", "Deploys a COMPound style governance system")
// .addParam("token", "The address to receive the initial supply")
// .addParam("timelock", "The timelock administrator")
// .addParam("guardian", "The governor guardian").setAction(async taskArgs => {

//   const { deploy } = require("./scripts/Deploy");

//     await deploy({
//       tokenRecipient: taskArgs.token,
//       timeLockAdmin: taskArgs.timelock,
//       guardian: taskArgs.guardian
//     });
// })
/**
 * @type import('hardhat/config').HardhatUserConfig
 * You have to export an object to set up your config
 * This object can have the following optional entries:
 * defaultNetwork, networks, solc, and paths.
 * Go to https://buidler.dev/config/ to learn more
 */
export const networks = {
  hardhat: {
    blockGasLimit: 1350000000,
    gas: 1300000000
  },
  matic: {
    url: 'https://rpc-mainnet.matic.network',
    accounts: [process.env.N3RD_INFURA_SECRET],
    blockGasLimit: 20000000,
    gasPrice: 1000000000
  },
  mumbai: {
    url: 'https://rpc-mumbai.matic.today',
    accounts: [process.env.N3RD_INFURA_SECRET],
    blockGasLimit: 20000000,
    gasPrice: 1000000000
  },
  kovan: {
    url: process.env.N3RD_INFURA_ENPOINT_KOVAN,
    accounts: [process.env.N3RD_INFURA_SECRET],
    gasPrice: 5000000000
  },
  rinkeby: {
    url: process.env.N3RD_INFURA_ENPOINT_RINKEBY,
    accounts: [process.env.N3RD_INFURA_SECRET]
  }
}
export const paths = {
  sources: "./contracts",
  tests: "./test",
  cache: "./cache",
  artifacts: "./artifacts"
}
export const mocha = {
  timeout: 20000
}
export const gasReporter = {
  currency: 'USD',
  gasPrice: 100,
  enabled: false
}
export const contractSizer = {
  alphaSort: false,
  runOnCompile: false,
  disambiguatePaths: false
}
export const solidity = {
  version: '0.7.6',
  settings: {
    optimizer: {
      enabled: true,
      runs: 20000
    }
  }
}
