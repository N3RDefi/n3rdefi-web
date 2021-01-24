import { networks } from '~/util/networks'
/* Filter the network by the HEX chainId received from MetaMask */
export function networkFilter(chainHEX) {
  const chainId = String(chainHEX)
  let networkName = ''
  switch (chainId) {
    case networks.MAIN_NET.hex:
      networkName = networks.MAIN_NET.name
      break
    case networks.BINANCE_MAIN_NET.hex:
      networkName = networks.BINANCE_MAIN_NET.name
      break
    case networks.ROPSTEN_TEST_NET.hex:
      networkName = networks.ROPSTEN_TEST_NET.name
      break
    case networks.RINKEBY_TEST_NET.hex:
      networkName = networks.RINKEBY_TEST_NET.name
      break
    case networks.GOERLI_TEST_NET.hex:
      networkName = networks.GOERLI_TEST_NET.name
      break
    case networks.KOVAN_TEST_NET.hex:
      networkName = networks.KOVAN_TEST_NET.name
      break
    case networks.BINANCE_TEST_NET.hex:
      networkName = networks.BINANCE_TEST_NET.name
      break
    case networks.MUMBAI_TEST_NET.hex:
      networkName = networks.MUMBAI_TEST_NET.name
      break
    case networks.TRUFFLE_DEV_NET.hex:
      networkName = networks.TRUFFLE_DEV_NET.name
      break
    case networks.GANACHE_DEV_NET.hex:
      networkName = networks.GANACHE_DEV_NET.name
      break
    default:
      networkName = 'No network found!'
  }
  return networkName
}
