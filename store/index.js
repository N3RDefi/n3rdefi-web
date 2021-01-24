const state = () => ({
  web3: {
    web3Instance: false,
    isMetaMask: false,
    chainId: null,
    chainIdHEX: null,
    chainName: null,
    account: null,
    balance: null,
  },
  contracts: {
    contractInstance: null,
    N3RDContract: null,
    N3RDyContract: null,
    N3RDaoContract: null,
    SAFUContract: null,
    SAFUSealContract: null,
  },
  user: null,
  nfts: [],
  nftCats: [],
  leftDrawerOpen: false,
  searchText: '',
})

const actions = {
  onAuthStateChangedAction(state, { account, nfts }) {
    if (!account) {
      // Remove state if now account
      state.commit('SET_ACCOUNT', null)
    } else {
      state.commit('SET_ACCOUNT', account)
    }
  },
  setupWeb3Account(state, { account }) {
    state.commit('SET_ACCOUNT', account)
  },
}

const mutations = {
  SET_WEB3_INSTANCE(state, payload) {
    /* The Browser has Ethereum installed but not connected */
    state.web3.web3Instance = payload
  },
  SET_IS_METAMASK(state, payload) {
    /* MetaMask is installed but not connected */
    state.web3.isMetaMask = payload
  },
  SET_CHAIN_ID(state, payload) {
    /* Set the chainId of network provider */
    state.web3.chainId = payload
  },
  SET_CHAIN_ID_HEX(state, payload) {
    /* Set the chainIdHEX of network provider */
    state.web3.chainIdHEX = payload
  },
  SET_CHAIN_NAME(state, payload) {
    /* Set the Network Name of network provider */
    state.web3.chainName = payload
  },
  SET_ACCOUNT(state, payload) {
    /* Set the web3Instance if Account */
    state.web3.web3Instance = true
    state.web3.account = payload
  },
  SET_BALANCE(state, payload) {
    /* Set the Balance of the Account */
    state.web3.balance = payload
  },
  SET_NFT(state, payload) {
    state.nfts.push(payload)
  },
  SET_NFT_CAT(state, payload) {
    state.nftCats.push(payload)
  },
  SET_SEARCH(state, payload) {
    state.searchText = payload
  },
  TOGGLE_LEFTDRAWER(state) {
    state.leftDrawerOpen = !state.leftDrawerOpen
  },
}

const getters = {
  getWeb3(state) {
    return state.web3.web3Instance
  },
  getWeb3Instance(state) {
    return state.web3.web3Instance
  },
  getChainId(state) {
    return state.web3.chainId
  },
  getChainIdHEX(state) {
    return state.web3.chainIdHEX
  },
  getAccount(state) {
    return state.web3.account
  },
  getBalance(state) {
    return state.web3.balance
  },
  getUser(state) {
    return state.user
  },
  getNfts(state) {
    return state.nfts
  },
  getNftCats(state) {
    return state.nftCats
  },
  getSearchText(state) {
    return state.searchText
  },
  getLeftDrawerState(state) {
    return state.leftDrawerOpen
  },
}

export default {
  state,
  actions,
  mutations,
  getters,
}
