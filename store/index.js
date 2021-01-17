const state = () => ({
  leftDrawerOpen: false,
  searchText: '',
  user: null,
  nfts: [],
  nftCats: [],
})

const actions = {
  onAuthStateChangedAction(state, { user, nfts }) {
    if (!user) {
      // Remove state if now user
      state.commit('CONNECT_USER', null)
      state.commit('SET_NFTS', null)
    } else {
      state.commit('CONNECT_USER', user)
      state.commit('SET_NFTS', nfts)
    }
  },
}

const mutations = {
  SEARCH(state, payload) {
    state.searchText = payload
  },
  TOGGLE_LEFTDRAWER(state, value) {
    state.leftDrawerOpen = !state.leftDrawerOpen
  },
  CONNECT_USER(state, user) {
    console.log('Connect User:')
    state.user = user
  },
  GENERATE_NFT(state, nft) {
    console.log('Generate NFT:', nft)
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
}

export default {
  state,
  actions,
  mutations,
  getters,
}
