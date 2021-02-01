/**
 * @plugin $web3
 * @extends Vue
 * @description My web3 helper plugin
 * @example
 *  this.$web3()
 *  this.$web3.getAccounts(account)
 */
import Vue from 'vue'
import Web3 from 'web3'
import detectEthereumProvider from '@metamask/detect-provider'
import { Arkane } from '@arkane-network/web3-arkane-provider/'
/* Contracts ABI */
import N3RDBEP20_ABI from '../contracts/abi/N3RDBEP20_ABI'
import N3RD_ABI from '../contracts/abi/N3RD_ABI'
import N3RDY_ABI from '../contracts/abi/N3RDY_ABI'
import N3RDAO_ABI from '../contracts/abi/N3RDAO_ABI'
import SAFU_ABI from '../contracts/abi/SAFU_ABI'
import SAFUSEAL_ABI from '../contracts/abi/SAFUSEAL_ABI'
/* Network Enum */
import { networks } from '../util/networks'

const network = networks.MUMBAI_TEST_NET
console.log('Choosen Network', network)

/* Contract Addresses */
const N3RDBEP20_ADDR =
  network.id === 1
    ? process.env.N3RD_CONTRACT_ADDRESS
    : process.env.N3RD_TEST_CONTRACT_ADDRESS
const N3RD_ADDR =
  network.id === 1
    ? process.env.N3RD_CONTRACT_ADDRESS
    : process.env.N3RD_TEST_CONTRACT_ADDRESS
const N3RDY_ADDR =
  network.id === 1
    ? process.env.N3RDY_CONTRACT_ADDRESS
    : process.env.N3RDY_TEST_CONTRACT_ADDRESS
const N3RDAO_ADDR =
  network.id === 1
    ? process.env.N3RDAO_CONTRACT_ADDRESS
    : process.env.N3RDAO_TEST_CONTRACT_ADDRESS
const SAFU_ADDR =
  network.id === 1
    ? process.env.SAFU_CONTRACT_ADDRESS
    : process.env.SAFU_TEST_CONTRACT_ADDRESS
const SAFUSEAL_ADDR =
  network.id === 1
    ? process.env.SAFUSEAL_CONTRACT_ADDRESS
    : process.env.SAFUSEAL_TEST_CONTRACT_ADDRESS
/* Ethereum && Binance Contract Address */
const ETH_ADDR = process.env.ETH_ACCOUNT
const BNB_ADDR = '0x0000000000000000000000000000000000000000'
const BSC_ADDR =
  network.id === 2
    ? process.env.BINANCE_SMART_CHAIN_MAINNET
    : process.env.BINANCE_SMART_CHAIN_TESTNET

console.log('ETH_ADDR', ETH_ADDR)
console.log('BNB_ADDR', BNB_ADDR)
console.log('BSC_ADDR', BSC_ADDR)
/* Arkane Options */
const arkaneOptions = {
  clientId: 'N3RDefi',
  // rpcUrl: 'https://kovan.infura.io/v3/YOUR-PROJECT-ID', // optional
  environment: 'staging', // optional, production by default possible values are 'local', 'tst1', 'staging', 'prod'
  windowMode: 'POPUP', // optional, REDIRECT by default
  useOverlayWithPopup: true,
  // bearerTokenProvider: () => 'obtained_bearer_token', // optional, default undefined
  // optional: you can set an identity provider to be used when authenticating
  authenticationOptions: {
    idpHint: 'google',
  },
}
/* Base function to check the Arkane Provider  */
const getArkaneProvider = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    Arkane.createArkaneProviderEngine(arkaneOptions).then((provider) => {
      return provider
    })
  } else {
    // If the provider is not detected, detectEthereumProvider resolves to null
    console.error('Please install MetaMask to continue!')
    return null
  }
  return null
}
/* Base function to check the Ethereum Provider  */
const getWeb3 = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    return provider
  }
  if (window.web3) {
    return new Web3(window.web3)
  }
  // If the provider is not detected, detectEthereumProvider resolves to null
  console.error('Please install MetaMask to continue!')
  return null
}
/* Base web3 Helper to check provider -> USAGE: this.$web3()  */
const web3 = () => {
  const newWeb3 = getWeb3()
  return newWeb3
}
/* Connect the Arkane Provider */
web3.connectArkaneProvider = async () => {
  const arkaneProvider = await getArkaneProvider()
  return arkaneProvider
}
/* Connect Metamask, returns first Account */
web3.connectMetaMask = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    /* Will also start the MetaMask extension */
    const accounts = await provider
      .request({
        method: 'eth_requestAccounts',
      })
      // .then(handleAccountsChanged)
      .catch((error) => {
        if (error.code === 4001) {
          // EIP-1193 userRejectedRequest error
          console.log('Please connect to MetaMask.')
        } else {
          console.error(error)
        }
      })
    // We currently only ever provide a single account,
    // but the array gives us some room to grow.
    const [...account] = accounts
    return account
  }
  return false
}
/* Gets First Account from Metamask */
web3.getAccount = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    /* Will get the accounts from Metamask or web3 Provider */
    const accounts = await provider.request({
      method: 'eth_accounts',
    })
    // We currently only ever provide a single account,
    // but the array gives us some room to grow.
    const [...account] = accounts
    return account
  }
  return ''
}
/* Gets All Accounts from Metamask */
web3.getAccounts = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    /* Will Start the metamask extension */
    const accounts = await provider.request({
      method: 'eth_accounts',
    })
    return accounts
  }
  return false
}
/* Gets The Network or ChainId, returned as a HEX from MetaMask */
web3.getChainId = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    /* Will Start the metamask extension */
    const chainId = await provider.request({
      method: 'eth_chainId',
    })
    return chainId
  }
  return false
}
/* Get the Account Balance */
web3.getBalance = async (account) => {
  const provider = await detectEthereumProvider()
  if (provider) {
    const newWeb3 = new Web3(window.ethereum)
    await newWeb3.eth.getBalance(String(account), 'latest', (err, result) => {
      if (err) {
        console.log(err)
      } else {
        return newWeb3.utils.fromWei(result, 'ether')
      }
      return 0
    })
  }
  return 0
}
/* Send a Transaction */
web3.sendTransaction = async (from, to, value, gas, gasPrice) => {
  const provider = await detectEthereumProvider()
  if (provider) {
    /* In MetaMask, using the ethereum.request method directly, sending a transaction will involve composing an options object like this: */
    // const transactionParameters = {
    //   nonce: '0x00', // ignored by MetaMask
    //   gasPrice: '0x09184e72a000', // customizable by user during MetaMask confirmation.
    //   gas: '0x2710', // customizable by user during MetaMask confirmation.
    //   to: '0x0000000000000000000000000000000000000000', // Required except during contract publications.
    //   from: ethereum.selectedAddress, // must match user's active address.
    //   value: '0x00', // Only required to send ether to the recipient from the initiating external account.
    //   data:
    //     '0x7f7465737432000000000000000000000000000000000000000000000000000000600057', // Optional, but used for defining smart contract creation and interaction.
    //   chainId: '0x3', // Used to prevent transaction reuse across blockchains. Auto-filled by MetaMask.
    // };

    try {
      // txHash is a hex string, as with any RPC call, it may throw an error
      const transactionHash = await provider.request({
        method: 'eth_sendTransaction',
        params: [
          {
            from,
            to,
            value,
            gas,
            gasPrice,
          },
        ],
      })
      // Handle the result
      console.log(transactionHash)
    } catch (error) {
      console.error(error)
    }
  }
  return false
}

/* Error log -> USAGE: this.$web3.getExplorerURL(network)  */
web3.getExplorerURL = (explorer) => {
  console.log(
    `%c[ Console Log Here : ]\n${JSON.stringify(...explorer, null, 4)}`,
    'color: lightGreen'
  )
  return 'https://testnet.bscscan.com//'
}
/* N3RDBEP20 Contract */
web3.getN3RDBEP20TokenContract = async () => {
  const newWeb3 = getWeb3()
  return new newWeb3.eth.Contract(N3RDBEP20_ABI, N3RDBEP20_ADDR)
}
web3.getN3RDBEP20TokenName = async () => {
  const contractToken = this.getN3RDBEP20TokenContract(N3RDBEP20_ADDR)
  return contractToken.methods.name().call()
}
web3.getN3RDBEP20TokenContractSymbol = async () => {
  const newWeb3 = getWeb3()
  const contractToken = new newWeb3.eth.Contract(N3RDBEP20_ABI, N3RDBEP20_ADDR)
  return contractToken.methods.symbol().call()
}

/* N3RD ERC 20 Contract */
web3.getN3RDTokenContract = async () => {
  const newWeb3 = getWeb3()
  return new newWeb3.eth.Contract(N3RD_ABI, N3RD_ADDR)
}
web3.getN3RDTokenName = async () => {
  const contractToken = this.getN3RDTokenContract(N3RD_ADDR)
  return contractToken.methods.name().call()
}
web3.getN3RDTokenSymbol = async () => {
  const newWeb3 = getWeb3()
  const contractToken = new newWeb3.eth.Contract(N3RD_ABI, N3RD_ADDR)
  return contractToken.methods.symbol().call()
}

/* N3RDy Contract */
web3.getN3RDYTokenContract = async () => {
  const newWeb3 = getWeb3()
  return new newWeb3.eth.Contract(N3RDY_ABI, N3RDY_ADDR)
}
web3.getN3RDYTokenName = async () => {
  const contractToken = this.getN3RDYTokenContract(N3RDY_ADDR)
  return contractToken.methods.name().call()
}
web3.getN3RDYTokenSymbol = async () => {
  const newWeb3 = getWeb3()
  const contractToken = new newWeb3.eth.Contract(N3RDY_ABI, N3RDY_ADDR)
  return contractToken.methods.symbol().call()
}

/* N3RDao Contract */
web3.getN3RDAOTokenContract = async () => {
  const newWeb3 = getWeb3()
  return new newWeb3.eth.Contract(N3RDAO_ABI, N3RDAO_ADDR)
}
web3.getN3RDAOTokenContractName = async () => {
  const contractToken = this.getN3RDAOTokenContract(N3RDAO_ADDR)
  return contractToken.methods.name().call()
}
web3.getN3RDAOTokenSymbol = async () => {
  const newWeb3 = getWeb3()
  const contractToken = new newWeb3.eth.Contract(N3RDAO_ABI, N3RDAO_ADDR)
  return contractToken.methods.symbol().call()
}

/* SAFU Protocol Contract */
web3.getSAFUTokenContract = async () => {
  const newWeb3 = getWeb3()
  return new newWeb3.eth.Contract(SAFU_ABI, SAFU_ADDR)
}
web3.getSAFUTokenName = async () => {
  const contractToken = this.getSAFUTokenContract(SAFU_ADDR)
  return contractToken.methods.name().call()
}
web3.getSAFUTokenSymbol = async () => {
  const newWeb3 = getWeb3()
  const contractToken = new newWeb3.eth.Contract(SAFU_ABI, SAFU_ADDR)
  return contractToken.methods.symbol().call()
}

/* SAFU Seal Contract */
web3.getSAFUSEALTokenContract = async () => {
  const newWeb3 = getWeb3()
  return new newWeb3.eth.Contract(SAFUSEAL_ABI, SAFUSEAL_ADDR)
}
web3.getSAFUSEALTokenName = async () => {
  const contractToken = this.getSAFUSEALTokenContract(SAFUSEAL_ADDR)
  return contractToken.methods.name().call()
}
web3.getSAFUSEALTokenSymbol = async () => {
  const newWeb3 = getWeb3()
  const contractToken = new newWeb3.eth.Contract(SAFUSEAL_ABI, SAFUSEAL_ADDR)
  return contractToken.methods.symbol().call()
}

/* Setup Namespace */
web3.install = (Vue) => {
  Vue.prototype.$web3 = web3
}

/* Init */
Vue.use(web3)
