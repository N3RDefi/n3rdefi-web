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
/* Contracts ABI */
import N3RD_ABI from '~/contracts/abi/N3RD_ABI'
import N3RDY_ABI from '~/contracts/abi/N3RDY_ABI'
import N3RDAO_ABI from '~/contracts/abi/N3RDAO_ABI'
import SAFU_ABI from '~/contracts/abi/SAFU_ABI'
import SAFUSEAL_ABI from '~/contracts/abi/SAFUSEAL_ABI'
/* Network Enum */
import { networks } from '~/util/networks.js'
const network = networks.MUMBAI_TEST_NET
// console.log('Choosen Network', network)
/* Contract Addresses */
const BNB_ADDR = '0x0000000000000000000000000000000000000000'
const N3RD_ADDR =
  network === 1
    ? '0xfb0349F08e2078a2944Ae3205446D176c3b45373'
    : '0xE4Ae305ebE1AbE663f261Bc00534067C80ad677C'
const N3RDY_ADDR =
  network === 1
    ? '0xfb0349F08e2078a2944Ae3205446D176c3b45373'
    : '0xE4Ae305ebE1AbE663f261Bc00534067C80ad677C'
const N3RDAO_ADDR =
  network === 1
    ? '0x4b38dCD3E3f422F33Ef1F49eD3A3F11c7A5d27bC'
    : '0x04e283c9350Bab8A1243ccfc1dd9BF1Ab72dF4f0'
const SAFU_ADDR =
  network === 1
    ? '0x94fFAD4568fF00D921C76aA158848b33D7Bd65d3'
    : '0x4ab5b40746566c09f4B90313D0801D3b93f56EF5'
const SAFUSEAL_ADDR =
  network === 1
    ? '0xeFD9BfFe7c63Ab5962648E3e83e44306C4dAD747'
    : '0xCaF0366aF95E8A03E269E52DdB3DbB8a00295F91'

/* Base function to check the Provider  */
const getWeb3 = async () => {
  const provider = await detectEthereumProvider()
  if (provider) {
    // console.log(
    //   `%c Ethereum successfully detected! : ${JSON.stringify(
    //     window.ethereum,
    //     null,
    //     4
    //   )}`,
    //   'background: #222; color: #bada55'
    // )
    return window.ethereum
  } else if (window.web3) {
    console.log('Old Web3 is installed!', window.web3.currentProvider)
    return new Web3(window.web3)
  } else {
    // If the provider is not detected, detectEthereumProvider resolves to null
    console.error('Please install MetaMask to continue!')
    return null
  }
}
/* Base web3 Helper to check provider -> USAGE: this.$web3()  */
const web3 = () => {
  const web3_ = getWeb3()
  return web3_
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
    const web3 = new Web3(window.ethereum)
    let displayBalance_ = 0
    const balance = await web3.eth.getBalance(
      String(account),
      'latest',
      (err, result) => {
        if (err) {
          console.log(err)
        } else {
          displayBalance_ = web3.utils.fromWei(result, 'ether')
        }
      }
    )
    return displayBalance_ || 0
  }
  return 0
}
/* Send a Transaction */
web3.sendTransaction = async (to, from, value) => {
  const provider = await detectEthereumProvider()
  if (provider) {
    try {
      const transactionHash = await provider.request({
        method: 'eth_sendTransaction',
        params: [
          {
            to,
            from,
            value,
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
web3.getExplorerURL = (network) => {
  console.log(
    `%c[ Console Log Here : ]\n${JSON.stringify(...network, null, 4)}`,
    'color: lightGreen'
  )
  return 'https://testnet.bscscan.com//'
}

web3.getN3RDTokenContract = () => {
  const web3 = getWeb3()
  return new web3.eth.Contract(N3RD_ABI, N3RD_ADDR)
}
web3.getN3RDYTokenContract = () => {
  const web3 = getWeb3()
  return new web3.eth.Contract(N3RDY_ABI, N3RDY_ADDR)
}
web3.getN3RDAOTokenContract = () => {
  const web3 = getWeb3()
  return new web3.eth.Contract(N3RDAO_ABI, N3RDAO_ADDR)
}
web3.getSAFUTokenContract = () => {
  const web3 = getWeb3()
  return new web3.eth.Contract(SAFU_ABI, SAFU_ADDR)
}
web3.getSAFUSEALTokenContract = () => {
  const web3 = getWeb3()
  return new web3.eth.Contract(SAFUSEAL_ABI, SAFUSEAL_ADDR)
}

web3.getTokenSymbol = (address) => {
  const web3 = getWeb3()
  const contractToken = new web3.eth.Contract(N3RD_ABI, address)
  return contractToken.methods.symbol().call()
}

/* Setup Namespace */
web3.install = (Vue) => {
  Vue.prototype.$web3 = web3
}

/* Init */
Vue.use(web3)
