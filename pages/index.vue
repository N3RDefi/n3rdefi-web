<template>
  <q-layout view="lHh Lpr fff" class="bg-grey-1">
    <Header />
    <SidebarLeft />
    <q-page-container class="GPL__page-container">
      <!-- <router-view /> -->
      <q-page padding>
        <!-- First Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Intro />
          </div>
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <IntroBoard />
          </div>
        </div>
        <!-- END First Row -->
        <!-- Second Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-3 col-lg-3 col-md-3 col-sm-12 col-xs-12 q-pa-sm">
            <NFTGenerator />
          </div>
          <div class="col-9 col-lg-9 col-md-9 col-sm-12 col-xs-12 q-pa-sm">
            <NFTHero />
          </div>
        </div>
        <!-- END Second Row -->
        <!-- Third Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <D3fi />
          </div>
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Seal />
          </div>
        </div>
        <!-- END Third Row -->
        <!-- Fourth Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <G3fi />
          </div>
        </div>
        <!-- END Fourth Row -->
        <!-- Fifth Row - Intro & Connect -->
        <div class="row items-start justify-evenly">
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Incubator />
          </div>
          <div class="col-6 col-lg-6 col-md-6 col-sm-12 col-xs-12 q-pa-sm">
            <Academy />
          </div>
        </div>
      </q-page>
      <PageStickyMenu />
    </q-page-container>
  </q-layout>
</template>
<script>
/* Import Vuex State, Getters and Mutations */
import { mapState, mapGetters } from 'vuex'
/* Enums and Network Helper */
import { networkFilter } from '../util/networkFilter'
/* Components */
import Header from '../components/Header.vue'
import SidebarLeft from '../components/SidebarLeft.vue'
import PageStickyMenu from '../components/PageStickyMenu.vue'
import Intro from '../components/Intro.vue'
import IntroBoard from '../components/IntroBoard.vue'
import NFTGenerator from '../components/NFTGenerator.vue'
import NFTHero from '../components/NFTHero.vue'
import D3fi from '../components/D3fi.vue'
import Seal from '../components/Seal.vue'
import G3fi from '../components/G3fi.vue'
import Incubator from '../components/Incubator.vue'
import Academy from '../components/Academy.vue'
/* LFG */
export default {
  name: 'N3RD',
  components: {
    Header,
    SidebarLeft,
    PageStickyMenu,
    Intro,
    IntroBoard,
    NFTGenerator,
    NFTHero,
    D3fi,
    Seal,
    G3fi,
    Incubator,
    Academy,
  },
  data() {
    return {}
  },
  computed: {
    ...mapState(['web3', 'user', 'profile']),
    ...mapGetters({
      getWeb3: 'getWeb3',
      getUser: 'getUser',
      getProfile: 'getProfile',
      getChainIdHEX: 'getChainIdHEX',
    }),
    web3: {
      get() {
        return this.$store.state.web3
      },
      set(value) {
        this.$store.commit('SET_WEB3', value)
      },
    },
    user: {
      get() {
        return this.$store.state.user
      },
      set(value) {
        this.$store.commit('SET_USER', value)
      },
    },
    profile: {
      get() {
        return this.$store.state.profile
      },
      set(value) {
        this.$store.commit('SET_PROFILE', value)
      },
    },
  },
  async beforeCreate() {
    /* Check Web3 Instance */
    const web3 = await this.$web3()
    console.log(
      `%c Web3 detected beforeCreate : ${JSON.stringify(web3, null, 4)}`,
      'background: #222; color: #bada55'
    )
    if (web3) {
      this.$store.commit('SET_WEB3', web3)
      this.$store.commit('SET_WEB3_INSTANCE', true)
      if (web3 && web3.isMetaMask === true) {
        this.$store.commit('SET_IS_METAMASK', true)
      }
      /* Load User Account Info into the store */
      const accountLoaded = await this.loadAccount()
      if (accountLoaded) {
        console.log(
          '%c MetaMask loaded successfully!',
          'background: green; color: white'
        )
      } else {
        console.log(
          '%c Please connect MetaMask!',
          'background: red; color: white'
        )
      }
    }
  },
  methods: {
    async loadAccount() {
      /* Load Account, Chain Info and Balance/s */
      const account = await this.$web3.getAccount()
      if (account[0] && account[0] !== '') {
        this.$store.commit('SET_ACCOUNT', account)
        const chainIdHEX = await this.$web3.getChainId(account)
        this.$store.commit('SET_CHAIN_ID_HEX', chainIdHEX)
        const chainId = networkFilter(chainIdHEX, 'id')
        this.$store.commit('SET_CHAIN_ID', chainId)
        const chainName = networkFilter(chainIdHEX, 'name')
        this.$store.commit('SET_CHAIN_NAME', chainName)
        const balance = await this.$web3.getBalance(account)
        this.$store.commit('SET_BALANCE', balance)
        return true
      }
      return false
    },
  },
}
</script>
