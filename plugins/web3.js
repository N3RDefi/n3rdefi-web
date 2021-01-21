/**
 * @plugin $web3
 * @extends Vue
 * @description My web3 helper plgin
 * @example
 *  this.$web3()
 *  this.$web3.getAccounts(account)
 */
import Vue from 'vue'
import Web3 from 'web3'
/* Contract ABI */
import N3RD_ABI from '~/contracts/abi'
import { networks } from '~/util/enums.js'

const net = networks.MUMBAI_TEST_NET

const BNB_ADDR = '0x0000000000000000000000000000000000000000'
const N3RD_ADDR =
  net === 1
    ? '0xfb0349F08e2078a2944Ae3205446D176c3b45373'
    : '0xE4Ae305ebE1AbE663f261Bc00534067C80ad677C'
const DAO_ADDR =
  net === 1
    ? '0x4b38dCD3E3f422F33Ef1F49eD3A3F11c7A5d27bC'
    : '0x04e283c9350Bab8A1243ccfc1dd9BF1Ab72dF4f0'
const SAFU_ADDR =
  net === 1
    ? '0x94fFAD4568fF00D921C76aA158848b33D7Bd65d3'
    : '0x4ab5b40746566c09f4B90313D0801D3b93f56EF5'
const UTILS_ADDR =
  net === 1
    ? '0xeFD9BfFe7c63Ab5962648E3e83e44306C4dAD747'
    : '0xCaF0366aF95E8A03E269E52DdB3DbB8a00295F91'

const getWeb3 = () => {
  if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!', window.ethereum.isMetaMask)
    return new Web3(window.ethereum)
  } else if (window.web3) {
    console.log('Old Web3 is installed!', window.web3.currentProvider)
    return new Web3(window.web3)
  } else {
    console.log('No Web3 installed!')
    return false
  }
}

/* Base log -> USAGE: this.$web3()  */
const web3 = () => {
  const web3_ = getWeb3()
  return web3_
}

/* Error log -> USAGE: this.$web3.getExplorerURL(network)  */
web3.getExplorerURL = (network) => {
  console.log(
    `%c[ Console Log Here : ]\n${JSON.stringify(...network, null, 4)}`,
    'color: lightGreen'
  )
  return 'https://testnet.bscscan.com//'
}

web3.connectMetaMask = async () => {
  if (window.ethereum) {
    /* Will Start the metamask extension */
    const accounts = await window.ethereum.request({
      method: 'eth_requestAccounts',
    })
    // We currently only ever provide a single account,
    // but the array gives us some room to grow.
    const [...account] = accounts
    return account
  }
  return false
}

web3.getAccounts = async () => {
  const web3_ = getWeb3()
  const accounts = await web3_.ethereum.request({
    method: 'eth_requestAccounts',
  })
  return accounts
}

web3.getBalance = async (account) => {
  const web3_ = getWeb3()
  const balance_ = await web3_.eth.getBalance(String(account), 'latest')
  const displayBalance_ = web3_.utils.fromWei(balance_, 'ether')
  return displayBalance_
}

web3.getTokenContract = (address) => {
  const web3 = getWeb3()
  return new web3.eth.Contract(N3RD_ABI, address)
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
