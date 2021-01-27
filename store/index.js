import pollWeb3 from '../util/pollWeb3'

const state = () => ({
  web3: {},
  user: {
    web3Instance: false,
    isMetaMask: false,
    chainIdHEX: null,
    chainId: null,
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
  nfts: [],
  nftCats: [],
  searchText: '',
  leftDrawerOpen: false,
})

const actions = {
  pollWeb3({ commit }, payload) {
    commit('POLL_WEB3', payload)
  },
}

const mutations = {
  SET_WEB3(state, payload) {
    /* The Browser has Ethereum installed but not connected */
    Object.assign(state.web3, payload)
    pollWeb3()
  },
  POLL_WEB3(state, payload) {
    console.log('pollWeb3Instance mutation being executed', payload)
    state.user.account = payload.account
    state.user.chainIdHEX = payload.chainIdHEX
    state.user.chainName = payload.chainName
    state.user.balance = payload.balance
  },
  SET_USER(state, payload) {
    /* Set the User Object as a whole */
    Object.assign(state.user, payload)
  },
  SET_WEB3_INSTANCE(state, payload) {
    /* The User has Ethereum installed but not connected */
    state.user.web3Instance = payload
  },
  SET_IS_METAMASK(state, payload) {
    /* MetaMask is installed but not connected */
    state.user.isMetaMask = payload
  },
  SET_CHAIN_ID(state, payload) {
    /* Set the chainId of network provider */
    state.user.chainId = payload
  },
  SET_CHAIN_ID_HEX(state, payload) {
    /* Set the chainIdHEX of network provider */
    state.user.chainIdHEX = payload
  },
  SET_CHAIN_NAME(state, payload) {
    /* Set the Network Name of network provider */
    state.user.chainName = payload
  },
  SET_ACCOUNT(state, payload) {
    /* Set the Users default Account */
    state.user.account = payload
  },
  SET_BALANCE(state, payload) {
    /* Set the Balance of the Users account */
    state.user.balance = payload
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
    return state.web3
  },
  getUser(state) {
    return state.user
  },
  getWeb3Instance(state) {
    return state.user.web3Instance
  },
  getIsMetaMask(state) {
    return state.user.isMetaMask
  },
  getChainId(state) {
    return state.user.chainId
  },
  getChainIdHEX(state) {
    return state.user.chainIdHEX
  },
  getChainName(state) {
    return state.user.chainName
  },
  getAccount(state) {
    return state.user.account
  },
  getBalance(state) {
    return state.user.balance
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
