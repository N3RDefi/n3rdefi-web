import { networks } from './networks'
/* Filter the network by the HEX chainId received from MetaMask */
/* filterType returns the Pretty name or the Id */
export function networkFilter(chainHEX, filterType) {
  let network = ''
  const chainIdentifier = String(chainHEX)
  switch (chainIdentifier) {
    case networks.MAIN_NET.hex:
      network =
        filterType === 'name' ? networks.MAIN_NET.name : networks.MAIN_NET.id
      break
    case networks.BINANCE_MAIN_NET.hex:
      network =
        filterType === 'name'
          ? networks.BINANCE_MAIN_NET.name
          : networks.BINANCE_MAIN_NET.id
      break
    case networks.ROPSTEN_TEST_NET.hex:
      network =
        filterType === 'name'
          ? networks.ROPSTEN_TEST_NET.name
          : networks.ROPSTEN_TEST_NET.id
      break
    case networks.RINKEBY_TEST_NET.hex:
      network =
        filterType === 'name'
          ? networks.RINKEBY_TEST_NET.name
          : networks.RINKEBY_TEST_NET.id
      break
    case networks.GOERLI_TEST_NET.hex:
      network =
        filterType === 'name'
          ? networks.GOERLI_TEST_NET.name
          : networks.GOERLI_TEST_NET.id
      break
    case networks.KOVAN_TEST_NET.hex:
      network =
        filterType === 'name'
          ? networks.KOVAN_TEST_NET.name
          : networks.KOVAN_TEST_NET.id
      break
    case networks.BINANCE_TEST_NET.hex:
      network =
        filterType === 'name'
          ? networks.BINANCE_TEST_NET.name
          : networks.BINANCE_TEST_NET.id
      break
    case networks.MATIC_MAIN_NET.hex:
      network =
        filterType === 'name'
          ? networks.MATIC_MAIN_NET.name
          : networks.MATIC_MAIN_NET.id
      break
    case networks.MUMBAI_TEST_NET.hex:
      network =
        filterType === 'name'
          ? networks.MUMBAI_TEST_NET.name
          : networks.MUMBAI_TEST_NET.id
      break
    case networks.TRUFFLE_DEV_NET.hex:
      network =
        filterType === 'name'
          ? networks.TRUFFLE_DEV_NET.name
          : networks.TRUFFLE_DEV_NET.id
      break
    case networks.GANACHE_DEV_NET.hex:
      network =
        filterType === 'name'
          ? networks.GANACHE_DEV_NET.name
          : networks.GANACHE_DEV_NET.id
      break
    case networks.LOCALHOST.hex:
      network =
        filterType === 'name' ? networks.LOCALHOST.name : networks.LOCALHOST.id
      break
    default:
      network =
        filterType === 'name' ? networks.LOCALHOST.name : networks.LOCALHOST.id
  }
  return network
}
