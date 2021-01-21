const state = () => ({
  web3: {
    web3Instance: false,
    networkId: null,
    coinbase: null,
    balance: null,
  },
  contractInstance: null,
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
      state.commit('CONNECT_ACCOUNT', null)
      state.commit('SET_NFTS', null)
    } else {
      state.commit('CONNECT_ACCOUNT', account)
      state.commit('SET_NFTS', nfts)
    }
  },
  setupWeb3Account(state, { account }) {
    console.log('setupWeb3Account:', account)
    state.commit('CONNECT_ACCOUNT', account)
  },
}

const mutations = {
  SEARCH(state, payload) {
    state.searchText = payload
  },
  TOGGLE_LEFTDRAWER(state, value) {
    state.leftDrawerOpen = !state.leftDrawerOpen
  },
  WEB3INSTANCE(state, payload) {
    console.log('WEB3INSTANCE:', payload.networkId)
    state.web3.web3Instance = !!payload.networkId
    if (payload.networkId) {
      state.web3.networkId = payload.networkId
    }
  },
  CONNECT_ACCOUNT(state, payload) {
    /* Set the web3Instance if Account */
    state.web3.web3Instance = true
    state.web3.coinbase = payload
  },
  SET_NETWORK(state, payload) {
    /* Set the networkId of MetaMask */
    state.web3.networkId = payload
  },
  SET_BALANCE(state, payload) {
    /* Set the Balance of the Account */
    state.web3.balance = payload
  },
  GENERATE_NFT(state, payload) {
    console.log('GENERATE_NFT:', payload)
    // state.nfts.push(nft)
  },
}

const getters = {
  getSearchText(state) {
    return state.searchText
  },
  getLeftDrawerState(state) {
    return state.leftDrawerOpen
  },
  getUser(state) {
    return state.user
  },
  getNfts(state) {
    return state.nfts
  },
  web3Instance(state) {
    return state.web3
  },
}

export default {
  state,
  actions,
  mutations,
  getters,
}
