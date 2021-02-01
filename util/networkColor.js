import { networks } from './networks'
/* Filter the network Color or icon by the HEX chainId received from MetaMask */
/* filterType returns the Pretty icon or the Color */
export function networkColor(chainHEX, filterType) {
  let network = ''
  const chainIdentifier = String(chainHEX)
  switch (chainIdentifier) {
    case networks.MAIN_NET.hex:
      network =
        filterType === 'icon' ? networks.MAIN_NET.icon : networks.MAIN_NET.color
      break
    case networks.BINANCE_MAIN_NET.hex:
      network =
        filterType === 'icon'
          ? networks.BINANCE_MAIN_NET.icon
          : networks.BINANCE_MAIN_NET.color
      break
    case networks.ROPSTEN_TEST_NET.hex:
      network =
        filterType === 'icon'
          ? networks.ROPSTEN_TEST_NET.icon
          : networks.ROPSTEN_TEST_NET.color
      break
    case networks.RINKEBY_TEST_NET.hex:
      network =
        filterType === 'icon'
          ? networks.RINKEBY_TEST_NET.icon
          : networks.RINKEBY_TEST_NET.color
      break
    case networks.GOERLI_TEST_NET.hex:
      network =
        filterType === 'icon'
          ? networks.GOERLI_TEST_NET.icon
          : networks.GOERLI_TEST_NET.color
      break
    case networks.KOVAN_TEST_NET.hex:
      network =
        filterType === 'icon'
          ? networks.KOVAN_TEST_NET.icon
          : networks.KOVAN_TEST_NET.color
      break
    case networks.BINANCE_TEST_NET.hex:
      network =
        filterType === 'icon'
          ? networks.BINANCE_TEST_NET.icon
          : networks.BINANCE_TEST_NET.color
      break
    case networks.MATIC_MAIN_NET.hex:
      network =
        filterType === 'icon'
          ? networks.MATIC_MAIN_NET.icon
          : networks.MATIC_MAIN_NET.color
      break
    case networks.MUMBAI_TEST_NET.hex:
      network =
        filterType === 'icon'
          ? networks.MUMBAI_TEST_NET.icon
          : networks.MUMBAI_TEST_NET.color
      break
    case networks.TRUFFLE_DEV_NET.hex:
      network =
        filterType === 'icon'
          ? networks.TRUFFLE_DEV_NET.icon
          : networks.TRUFFLE_DEV_NET.color
      break
    case networks.GANACHE_DEV_NET.hex:
      network =
        filterType === 'icon'
          ? networks.GANACHE_DEV_NET.icon
          : networks.GANACHE_DEV_NET.color
      break
    case networks.LOCALHOST.hex:
      network =
        filterType === 'icon' ? networks.LOCALHOST.icon : networks.LOCALHOST.color
      break
    default:
      network =
        filterType === 'icon' ? networks.LOCALHOST.icon : networks.LOCALHOST.color
  }
  return network
}
