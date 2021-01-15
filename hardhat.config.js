require("@nomiclabs/hardhat-waffle")
require('@nomiclabs/hardhat-ethers')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("Accounts", "Prints a list of Accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address)
  }
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
 */
module.exports = {
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/123abc123abc123abc123abc123abcde",
      accounts: [privateKey1, privateKey2, ...]
    }
  },
  solidity: {
    version: "0.5.15",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  }
}
