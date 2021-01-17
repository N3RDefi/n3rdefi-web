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
      state.commit('SET_USER', null)
      state.commit('SET_NFTS', null)
    } else {
      state.commit('SET_USER', user)
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
  SET_USER(state, user) {
    state.user = user
  },
  SET_NFTS(state, nfts) {
    state.nfts = nfts
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
