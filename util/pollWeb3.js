import Web3 from 'web3'
import detectEthereumProvider from '@metamask/detect-provider'
import { networkFilter } from './networkFilter'

const pollWeb3 = async () => {
  const provider = await detectEthereumProvider()
  setInterval(async () => {
    if (provider && $nuxt.$store.state.user) {
      if (
        provider.chainId !== $nuxt.$store.state.user.chainIdHEX ||
        provider.selectedAddress !== $nuxt.$store.state.user.account[0]
      ) {
        /* Will Check the Current Provider Chain Id Hex */
        const chainId = await provider.request({
          method: 'eth_chainId',
        })
        /* Will get the accounts from Metamask or web3 Provider */
        const accounts = await provider.request({
          method: 'eth_accounts',
        })
        // We currently only ever provide a single account,
        const [...newAccount] = accounts

        const web3 = new Web3(window.ethereum)
        let displayBalance = 0
        await web3.eth.getBalance(
          String(newAccount),
          'latest',
          (err, result) => {
            if (err) {
              console.log(err)
              displayBalance = 0
            } else {
              displayBalance = web3.utils.fromWei(result, 'ether')
            }
          }
        )
        $nuxt.$store.dispatch('pollWeb3', {
          account: newAccount,
          chainId: networkFilter(chainId, 'id'),
          chainIdHEX: String(chainId),
          chainName: networkFilter(chainId, 'name'),
          balance: displayBalance,
        })
      }
    }
  }, 3000)
}

export default pollWeb3
