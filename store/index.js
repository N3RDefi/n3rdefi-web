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
  profile: {
    userId: null,
    hasMasterPin: null,
    username: null,
    email: null,
    firstName: null,
    lastName: null,
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
  /* Web3 & Providers */
  SET_WEB3(state, payload) {
    Object.assign(state.web3, payload)
    pollWeb3()
  },
  POLL_WEB3(state, payload) {
    state.user.account = payload.account
    state.user.chainId = payload.chainId
    state.user.chainIdHEX = payload.chainIdHEX
    state.user.chainName = payload.chainName
    state.user.balance = payload.balance
  },
  /* User */
  SET_USER(state, payload) {
    Object.assign(state.user, payload)
  },
  SET_WEB3_INSTANCE(state, payload) {
    state.user.web3Instance = payload
  },
  SET_IS_METAMASK(state, payload) {
    state.user.isMetaMask = payload
  },
  SET_CHAIN_ID(state, payload) {
    state.user.chainId = payload
  },
  SET_CHAIN_ID_HEX(state, payload) {
    state.user.chainIdHEX = payload
  },
  SET_CHAIN_NAME(state, payload) {
    state.user.chainName = payload
  },
  SET_ACCOUNT(state, payload) {
    state.user.account = payload
  },
  SET_BALANCE(state, payload) {
    state.user.balance = payload
  },
  /* Arkane Profile */
  SET_PROFILE(state, payload) {
    Object.assign(state.profile, payload)
  },
  SET_PROFILE_USERID(state, payload) {
    state.profile.userId = payload
  },
  SET_PROFILE_HASMASTERPIN(state, payload) {
    state.profile.hasMasterPin = payload
  },
  SET_PROFILE_USERNAME(state, payload) {
    state.profile.username = payload
  },
  SET_PROFILE_EMAIL(state, payload) {
    state.profile.email = payload
  },
  SET_PROFILE_FIRSTNAME(state, payload) {
    state.profile.firstName = payload
  },
  SET_PROFILE_LASTNAME(state, payload) {
    state.profile.lastName = payload
  },
  /* Contracts */
  SET_CONTRACT_INSTANCE(state, payload) {
    state.contracts.contractInstance = payload
  },
  SET_CONTRACT_N3RDCONTRACT(state, payload) {
    state.contracts.N3RDContract = payload
  },
  SET_CONTRACT_N3RDYCONTRACT(state, payload) {
    state.contracts.N3RDyContract = payload
  },
  SET_CONTRACT_N3RDAOCONTRACT(state, payload) {
    state.contracts.N3RDaoContract = payload
  },
  SET_CONTRACT_SAFUCONTRACT(state, payload) {
    state.contracts.SAFUContract = payload
  },
  SET_CONTRACT_SAFUSEALCONTRACT(state, payload) {
    state.contracts.SAFUSealContract = payload
  },
  /* NFTs */
  SET_NFT(state, payload) {
    state.nfts.push(payload)
  },
  SET_NFT_CAT(state, payload) {
    state.nftCats.push(payload)
  },
  /* Website */
  SET_SEARCH(state, payload) {
    state.searchText = payload
  },
  TOGGLE_LEFTDRAWER(state) {
    state.leftDrawerOpen = !state.leftDrawerOpen
  },
}

const getters = {
  /* Web3 */
  getWeb3(state) {
    return state.web3
  },
  /* User */
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
  /* Profile */
  getProfile(state) {
    return state.profile
  },
  getUserId(state) {
    return state.profile.userId
  },
  getHasMasterPin(state) {
    return state.profile.hasMasterPin
  },
  getUsername(state) {
    return state.profile.username
  },
  getEmail(state) {
    return state.profile.email
  },
  getFirstName(state) {
    return state.profile.firstName
  },
  getLastName(state) {
    return state.profile.lastName
  },
  /* Contracts */
  getContractInstance(state) {
    return state.contracts.contractInstance
  },
  getN3RDContract(state) {
    return state.contracts.N3RDContract
  },
  getN3RDyContract(state) {
    return state.contracts.N3RDyContract
  },
  getN3RDaoContract(state) {
    return state.contracts.N3RDaoContract
  },
  getSAFUContract(state) {
    return state.contracts.SAFUContract
  },
  getSAFUSealContract(state) {
    return state.contracts.SAFUSealContract
  },
  /* NFTs */
  getNfts(state) {
    return state.nfts
  },
  getNftCats(state) {
    return state.nftCats
  },
  /* Website */
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
